import { serve } from "https://deno.land/std@0.208.0/http/server.ts";

interface CountryResponse {
  country_code: string;
  country_name: string;
  source: string;
}

// ISO 3166-1 alpha-2 → country name map (subset covering common codes)
const COUNTRY_NAMES: Record<string, string> = {
  NA: "Namibia",
  ZA: "South Africa",
  BW: "Botswana",
  ZW: "Zimbabwe",
  ZM: "Zambia",
  AO: "Angola",
  MZ: "Mozambique",
  TZ: "Tanzania",
  KE: "Kenya",
  NG: "Nigeria",
  GH: "Ghana",
  ET: "Ethiopia",
  EG: "Egypt",
  MA: "Morocco",
  TN: "Tunisia",
  UG: "Uganda",
  CM: "Cameroon",
  CI: "Ivory Coast",
  SN: "Senegal",
  US: "United States",
  GB: "United Kingdom",
  DE: "Germany",
  FR: "France",
  IN: "India",
  CN: "China",
  BR: "Brazil",
  AU: "Australia",
  CA: "Canada",
  JP: "Japan",
  RU: "Russia",
  MX: "Mexico",
  IT: "Italy",
  ES: "Spain",
  NL: "Netherlands",
  PT: "Portugal",
  SE: "Sweden",
  NO: "Norway",
  DK: "Denmark",
  FI: "Finland",
  PL: "Poland",
  AR: "Argentina",
  CO: "Colombia",
  CL: "Chile",
  PE: "Peru",
  VE: "Venezuela",
  ID: "Indonesia",
  PK: "Pakistan",
  BD: "Bangladesh",
  PH: "Philippines",
  TH: "Thailand",
  VN: "Vietnam",
  TR: "Turkey",
  SA: "Saudi Arabia",
  AE: "United Arab Emirates",
  QA: "Qatar",
  KW: "Kuwait",
  IQ: "Iraq",
  IR: "Iran",
  IL: "Israel",
  JO: "Jordan",
  LB: "Lebanon",
  SY: "Syria",
  UA: "Ukraine",
  RO: "Romania",
  HU: "Hungary",
  CZ: "Czech Republic",
  SK: "Slovakia",
  AT: "Austria",
  CH: "Switzerland",
  BE: "Belgium",
  NZ: "New Zealand",
  SG: "Singapore",
  MY: "Malaysia",
  HK: "Hong Kong",
  KR: "South Korea",
  TW: "Taiwan",
};

function resolveCountryName(code: string): string {
  return COUNTRY_NAMES[code.toUpperCase()] ?? code;
}

serve(async (req: Request): Promise<Response> => {
  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Content-Type": "application/json",
  };

  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  // 1. Cloudflare header (most reliable when behind Cloudflare proxy)
  const cfCountry = req.headers.get("CF-IPCountry");
  if (cfCountry && cfCountry !== "XX" && cfCountry.length === 2) {
    const payload: CountryResponse = {
      country_code: cfCountry.toUpperCase(),
      country_name: resolveCountryName(cfCountry),
      source: "cloudflare",
    };
    return new Response(JSON.stringify(payload), { status: 200, headers: corsHeaders });
  }

  // 2. Vercel header
  const vercelCountry = req.headers.get("x-vercel-ip-country");
  if (vercelCountry && vercelCountry.length === 2) {
    const payload: CountryResponse = {
      country_code: vercelCountry.toUpperCase(),
      country_name: resolveCountryName(vercelCountry),
      source: "vercel",
    };
    return new Response(JSON.stringify(payload), { status: 200, headers: corsHeaders });
  }

  // 3. Generic forwarded-for / fly.io / railway headers
  const flyRegion = req.headers.get("fly-client-ip");
  const xCountry = req.headers.get("x-country") ?? req.headers.get("x-country-code");
  if (xCountry && xCountry.length === 2) {
    const payload: CountryResponse = {
      country_code: xCountry.toUpperCase(),
      country_name: resolveCountryName(xCountry),
      source: "header",
    };
    return new Response(JSON.stringify(payload), { status: 200, headers: corsHeaders });
  }

  // 4. Default fallback — Namibia (primary market)
  const fallback: CountryResponse = {
    country_code: "NA",
    country_name: "Namibia",
    source: "fallback",
  };
  return new Response(JSON.stringify(fallback), { status: 200, headers: corsHeaders });
});
