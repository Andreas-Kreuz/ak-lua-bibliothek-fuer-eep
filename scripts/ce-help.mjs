import { readFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, "..");

const packageJson = JSON.parse(readFileSync(path.join(repoRoot, "package.json"), "utf8"));
const version = packageJson.version;

const targets = [
    { name: "install", description: 'Install all dependencies (yarn built-in: run "yarn")' },
    { name: "check-tools", description: "Verify that all required external tools are available in PATH" },
    { name: "dev-app", description: "Start Vite dev server (port 5173) + Electron server with EEP data" },
    { name: "test-app", description: "Start E2E test environment with Cypress interactive UI" },
    { name: "dev-docs", description: "Start Jekyll documentation server with live reload (port 4000)" },
    { name: "check-lua", description: "Run luacheck linter + busted unit tests on Lua code" },
    { name: "check-e2e", description: "Run Cypress E2E tests headless" },
    { name: "check-doc", description: "Build Jekyll docs to detect errors (no server started)" },
    { name: "check", description: "Run all checks: check-lua + check-e2e + check-doc" },
    { name: "build", description: "Run all checks, then build Windows .exe and create EEP release package" },
    { name: "play", description: "Build and start Electron server for real-life testing with EEP" },
    { name: "ce-help", description: "Print this help message" },
];

const nameWidth = Math.max(...targets.map((t) => t.name.length));

console.log(`\nControl Extension v${version} — available yarn targets:\n`);
for (const { name, description } of targets) {
    console.log(`  yarn ${name.padEnd(nameWidth)}  ${description}`);
}
console.log("");
