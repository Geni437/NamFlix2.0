import { serve } from "https://deno.land/std@0.208.0/http/server.ts";

const LARAVEL_API_URL = Deno.env.get("LARAVEL_API_URL") ?? "";
const CRON_SECRET = Deno.env.get("CRON_SECRET") ?? "";

serve(async (req: Request): Promise<Response> => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  // When called manually (not via Supabase scheduler), verify the secret header
  const incomingSecret = req.headers.get("X-Cron-Secret");
  if (incomingSecret && incomingSecret !== CRON_SECRET) {
    return new Response(JSON.stringify({ error: "Forbidden" }), {
      status: 403,
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!LARAVEL_API_URL || !CRON_SECRET) {
    console.error("Missing required env vars: LARAVEL_API_URL or CRON_SECRET");
    return new Response(
      JSON.stringify({ success: false, error: "Server configuration error" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  console.log(`[sync-iptv-data] Triggering Laravel IPTV sync at ${new Date().toISOString()}`);

  try {
    // 55s timeout — Supabase Edge Functions hard-kill at 60s
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 55_000);

    const response = await fetch(`${LARAVEL_API_URL}/internal/sync-iptv`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Cron-Secret": CRON_SECRET,
        "Accept": "application/json",
      },
      signal: controller.signal,
    });

    clearTimeout(timeout);

    const body = await response.json();

    if (!response.ok) {
      console.error(`[sync-iptv-data] Laravel returned ${response.status}:`, body);
      return new Response(
        JSON.stringify({
          success: false,
          error: `Laravel sync failed with status ${response.status}`,
          detail: body,
        }),
        { status: 500, headers: { "Content-Type": "application/json" } },
      );
    }

    console.log("[sync-iptv-data] Sync triggered successfully:", body);
    return new Response(
      JSON.stringify({ success: true, message: "IPTV sync triggered", result: body }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    const isTimeout = message.includes("aborted") || message.includes("abort");
    console.error("[sync-iptv-data] Failed to reach Laravel API:", message);
    return new Response(
      JSON.stringify({
        success: false,
        error: isTimeout ? "Laravel API request timed out" : "Failed to reach Laravel API",
        detail: message,
      }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
