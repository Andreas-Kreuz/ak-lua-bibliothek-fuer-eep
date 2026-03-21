import { execSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// __dirname not required here, kept for style consistency with other scripts
void __dirname;

const tools = [
    { name: "lua", purpose: "Lua runtime           — required for: build, release", args: "-v" },
    { name: "luacheck", purpose: "Lua linter            — required for: check-lua, check, release" },
    { name: "busted", purpose: "Lua test runner       — required for: check-lua, check, release" },
    { name: "bundle", purpose: "Ruby Bundler / Jekyll — required for: dev-docs, check-doc, check, release" },
];

function isAvailable(command, args = "--version") {
    try {
        execSync(`${command} ${args}`, { stdio: "ignore" });
        return true;
    } catch {
        return false;
    }
}

const nameWidth = Math.max(...tools.map((t) => t.name.length));

let allOk = true;
console.log("\nChecking required external tools:\n");

for (const { name, purpose, args } of tools) {
    const ok = isAvailable(name, args);
    const status = ok ? "OK     " : "MISSING";
    console.log(`  [${status}]  ${name.padEnd(nameWidth)}  ${purpose}`);
    if (!ok) {
        allOk = false;
    }
}

console.log("");

if (!allOk) {
    console.error("One or more required tools are missing. Install them and ensure they are in PATH.\n");
    process.exit(1);
}

console.log("All required tools are available.\n");
