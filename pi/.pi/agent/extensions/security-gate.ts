import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  // Configuration: add or remove patterns as needed
  const dangerousPatterns = [
    /rm\s+/,            // Catch all rm commands
    /sudo\s+/,
    /dd\s+/,
    /mkfs/,
    /chmod\s+777/,
    /chown\s+root/,
    />\s+\//, // Overwriting system files
  ];

  // Intercept AI tool calls
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "bash") {
      const command = event.input.command || "";
      if (await checkCommand(command, ctx)) {
        return { block: true, reason: "Blocked by user via security-gate extension" };
      }
    }
  });

  // Intercept user ! commands
  pi.on("user_bash", async (event, ctx) => {
    if (await checkCommand(event.command, ctx)) {
      return { result: { output: "Blocked by user", exitCode: 1, cancelled: true, truncated: false } };
    }
  });

  async function checkCommand(command: string, ctx: any): Promise<boolean> {
    const isDangerous = dangerousPatterns.some(pattern => pattern.test(command));
    if (!isDangerous) return false;

    ctx.ui.notify("Waiting for manual confirmation for command...", "warning");
    const allowed = await ctx.ui.confirm(
      "🚨 Security Gate: Dangerous Command",
      `The command requested is:\n\n${command}\n\nDo you want to proceed?`
    );

    return !allowed;
  }
}
