/**
 * Session Switcher Extension
 *
 * Commands:
 *   /sessions       - Centered overlay picker for current project sessions
 *   /sessions all   - All sessions across projects
 *   /sessions new   - Create new session
 *   /sessions name  - Name current session
 *
 * Shortcut: Alt+S bound to built-in /resume via keybindings.json (bottom picker)
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { DynamicBorder, SessionManager } from "@mariozechner/pi-coding-agent";
import { Container, type SelectItem, SelectList, Text } from "@mariozechner/pi-tui";

function buildSessionItems(sessions: Array<{ name?: string; firstMessage: string; modified: Date; cwd: string; path: string }>, currentPath: string | undefined, showCwd: boolean): SelectItem[] {
	return sessions.map((s) => {
		const date = s.modified.toLocaleString();
		const label = s.name || s.firstMessage || "(empty)";
		const truncLabel = label.length > 60 ? label.slice(0, 57) + "..." : label;
		const current = s.path === currentPath ? " ◄" : "";
		const cwd = showCwd ? ` [${s.cwd}]` : "";
		return {
			value: s.path,
			label: `${truncLabel}${current}`,
			description: `${date}${cwd}`,
		};
	});
}

async function showSessionPicker(ctx: any, sessions: any[], currentPath: string | undefined, showCwd: boolean): Promise<string | null> {
	const items = buildSessionItems(sessions, currentPath, showCwd);
	if (items.length === 0) {
		ctx.ui.notify("No sessions found", "info");
		return null;
	}

	return ctx.ui.custom<string | null>(
		(tui: any, theme: any, _kb: any, done: (v: string | null) => void) => {
			const container = new Container();

			container.addChild(new DynamicBorder((s: string) => theme.fg("accent", s)));
			container.addChild(new Text(theme.fg("accent", theme.bold("Sessions")), 1, 0));

			const selectList = new SelectList(items, Math.min(items.length, 15), {
				selectedPrefix: (t: string) => theme.fg("accent", t),
				selectedText: (t: string) => theme.fg("accent", t),
				description: (t: string) => theme.fg("muted", t),
				scrollInfo: (t: string) => theme.fg("dim", t),
				noMatch: (t: string) => theme.fg("warning", t),
			});
			selectList.onSelect = (item: SelectItem) => done(item.value);
			selectList.onCancel = () => done(null);
			container.addChild(selectList);

			container.addChild(new Text(theme.fg("dim", "↑↓ navigate • type to filter • enter select • esc cancel"), 1, 0));
			container.addChild(new DynamicBorder((s: string) => theme.fg("accent", s)));

			return {
				render: (w: number) => container.render(w),
				invalidate: () => container.invalidate(),
				handleInput: (data: string) => { selectList.handleInput(data); tui.requestRender(); },
			};
		},
		{
			overlay: true,
			overlayOptions: {
				anchor: "center",
				width: "70%",
				minWidth: 50,
				maxHeight: "80%",
			},
		},
	);
}

export default function sessionSwitcher(pi: ExtensionAPI) {
	pi.registerCommand("sessions", {
		description: "Switch between sessions (args: all | new | name <text>)",
		getArgumentCompletions: (prefix) => {
			const opts = ["all", "new", "name"];
			const filtered = opts.filter((o) => o.startsWith(prefix));
			return filtered.length > 0 ? filtered.map((o) => ({ value: o, label: o })) : null;
		},
		handler: async (args, ctx) => {
			const arg = args.trim();

			if (arg === "new") {
				const result = await ctx.newSession();
				if (result.cancelled) ctx.ui.notify("New session cancelled", "info");
				return;
			}

			if (arg.startsWith("name")) {
				const name = arg.slice(4).trim();
				if (!name) {
					const input = await ctx.ui.input("Session Name", "Enter name for this session:");
					if (input) {
						pi.setSessionName(input);
						ctx.ui.notify(`Session named: ${input}`, "success");
					}
				} else {
					pi.setSessionName(name);
					ctx.ui.notify(`Session named: ${name}`, "success");
				}
				return;
			}

			const showAll = arg === "all";
			const sessions = showAll
				? await SessionManager.listAll()
				: await SessionManager.list(ctx.cwd);

			if (sessions.length === 0) {
				ctx.ui.notify("No sessions found", "info");
				return;
			}

			const currentPath = ctx.sessionManager.getSessionFile();
			const selected = await showSessionPicker(ctx, sessions, currentPath, showAll);
			if (!selected) return;

			if (selected === currentPath) {
				ctx.ui.notify("Already in this session", "info");
				return;
			}

			const result = await ctx.switchSession(selected);
			if (result.cancelled) ctx.ui.notify("Switch cancelled", "info");
		},
	});
}
