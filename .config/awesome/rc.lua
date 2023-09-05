-- vim: set foldmethod=marker:
-- Libraries {{{

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Custom libs for customized stuff
local widget = require("widget")

-- }}}

-- Error handling {{{

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Error...",
			text = tostring(err) })
		in_error = false
	end)
end

-- }}}

-- Variables {{{

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "thm.lua")

-- Important Directories
binDir = gears.filesystem.get_configuration_dir() .. "bin/"

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = terminal .. " -e nvim"

-- Modkey (Super) and Altkey
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.fair,
	awful.layout.suit.tile.right,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.top,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.floating,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}

-- }}}

-- Wibar {{{

--local tasklist_buttons = gears.table.join(
--	awful.button({ }, 3, function()
--		awful.menu.client_list({ theme = { width = 500 } })
--	end) )

-- Create a textclock widget
mytextclock = widget.textclock()

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Function for setting wallpaper
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper on screen-geometry change
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
	function(s)
		-- Set wallpaper
		set_wallpaper(s)

		-- Each screen has its own tag table.
		awful.tag( { "1", "2", "3" },
			s,
			awful.layout.layouts[1])

		-- Promptbox for each screen
		s.promptbox = awful.widget.prompt()
		
		-- Create an imagebox widget which will contain an icon indicating which layout we're using.
		-- We need one layoutbox per screen.
		s.mylayoutbox = awful.widget.layoutbox(s)
		
		-- Create a taglist widget
		s.mytaglist = awful.widget.taglist {
			screen	= s,
			filter	= awful.widget.taglist.filter.all,
			buttons = taglist_buttons }
		
		-- Create a tasklist widget
		s.mytasklist = awful.widget.tasklist {
			screen	= s,
			filter	= awful.widget.tasklist.filter.currenttags,
			buttons = tasklist_buttons }
		
		-- Create the wibox
		s.mywibox = wibox({
			height = 60,
			width = s.geometry.width,
			x = 0,
			y = 0,
			ontop = true,
			visible = false,
			screen = s })
		
		-- Add widgets to the wibox
		s.mywibox:setup {
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.container {
					mytextclock,
					widget = wibox.container.place,
					forced_width = 150 },
				s.mylayoutbox,
				s.mytaglist,
				s.promptbox },

			-- Middle widgets
			wibox.container {
				s.mytasklist,
				widget = wibox.container.place },

			{ -- Right Widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.systray() }
		}
end )

-- }}}

-- Key bindings {{{

globalkeys = gears.table.join(
	-- Volume Controls
	awful.key({ }, "XF86AudioRaiseVolume",	-- Raise Audio by 5%
		function()
			awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
		end ),
	awful.key({ }, "XF86AudioLowerVolume",	-- Lower Audio by 5%
		function()
			awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
		end ),
	awful.key({ }, "XF86AudioMute",	-- Toggle Audio Mute
		function()
			awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
		end ),
	awful.key({ modkey }, "F8",	-- Raise Audio by 5%
		function()
			awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
		end ),
	awful.key({ modkey }, "F7",	-- Lower Audio by 5%
		function()
			awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
		end ),
	awful.key({ modkey }, "F6",	-- Toggle Audio Mute
		function()
			awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
		end ),
	
	-- Media Controls
	awful.key({ }, "XF86AudioPlay",	-- Pause Playing Media
		function()
			awful.spawn("playerctl play-pause")
		end ),
	awful.key({ }, "XF86AudioNext",	-- Go to Next Track in Playing Media
		function()
			awful.spawn("playerctl next")
		end ),
	awful.key({ }, "XF86AudioPrev",	-- Go to Previous Track in Playing Media
		function()
			awful.spawn("playerctl previous")
		end ),
	awful.key({ }, "XF86AudioStop",	-- Go to Previous Track in Playing Media
		function()
			awful.spawn("playerctl -a stop")
		end ),

awful.key({ modkey }, "F11",	-- Pause Playing Media
    function()
        awful.spawn("playerctl play-pause")
    end ),
awful.key({ modkey }, "F12",	-- Go to Next Track in Playing Media
    function()
        awful.spawn("playerctl next")
    end ),
awful.key({ modkey }, "F10",	-- Go to Previous Track in Playing Media
    function()
        awful.spawn("playerctl previous")
    end ),
awful.key({ modkey }, "F9",	-- Go to Previous Track in Playing Media
    function()
        awful.spawn("playerctl -a stop")
    end ),

	-- Other binds I use a lot
	awful.key({ modkey }, "b",	-- Toggle Main Wibox
		function ()
			for s in screen do
				s.mywibox.visible = not s.mywibox.visible
			end
		end ),
	awful.key({ modkey }, "Print",	-- Take Screenshot of Focused Window
		function()
			awful.spawn.easy_async_with_shell("maim -unsm 5 | xclip -selection clipboard -t image/png")
		end ),
	awful.key({ modkey, "Control" }, "Print",	-- Select Region to Capture a Screenshot of
		function()
			awful.spawn.with_shell("maim -unsm 5 $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png")
		end ),
	awful.key({ modkey, "Shift" }, "Print",	-- Captures main laptop screen
		function()
			awful.spawn.with_shell("maim -unm 5 -g 1920x1080+0+0 $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png")
		end ),
	awful.key({ modkey, "Control", "Shift" }, "Print",	-- Captures main laptop screen
		function()
			awful.spawn.with_shell("maim -unm 5 -g 1920x1080+1920+0 $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png")
		end ),

	awful.key({ modkey }, "F2",	-- Decrement Backlight Brightness Level
		function()
			awful.spawn("xbacklight -dec 1")
		end ),
	awful.key({ modkey }, "F3",	-- Increment Backlight Brightness Level
		function()
			awful.spawn("xbacklight -inc 1")
		end ),

	-- Tag Navigation
	awful.key({ modkey,	      }, "Left",	-- View Previous Tag
		awful.tag.viewprev ),
	awful.key({ modkey,	      }, "Right",	-- View Next Tag
		awful.tag.viewnext ),
	awful.key({ modkey,	      }, "Escape",	-- Go Back to Last Active Tag
		awful.tag.history.restore ),
		
	-- Client Navigation
	awful.key({ modkey,	      }, "j",	-- Focus Next Client
		function ()
			awful.client.focus.byidx( 1)
		end ),
	awful.key({ modkey,	      }, "k",	-- Focus Previous Client
		function ()
			awful.client.focus.byidx(-1)
		end ),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j",	-- Swap Client with Next
		function ()
			awful.client.swap.byidx(  1)
		end ),
	awful.key({ modkey, "Shift"   }, "k",	-- Swap Client with Previous
		function ()
			awful.client.swap.byidx( -1)
		end ),
	awful.key({ modkey, "Control" }, "j",	-- Focus Next Screen
		function ()
			awful.screen.focus_relative( 1)
		end ),
	awful.key({ modkey, "Control" }, "k",	-- Focus Previous Screen
		function ()
			awful.screen.focus_relative(-1)
		end ),
	awful.key({ modkey,	      }, "u",	-- Jump to Urgent Client
		awful.client.urgent.jumpto ),
	awful.key({ modkey,	      }, "Tab", -- Go Back to Last Focused Client
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end ),
	
	-- Standard program
	awful.key({ modkey,	      }, "Return",	-- Open a terminal
		function ()
			awful.spawn(terminal)
		end ),
	awful.key({ modkey, "Control" }, "Return",	-- Open an Emacs frame
		function()
			awful.spawn("emacsclient -c")
		end ),
    awful.key({ modkey, "Control", "Shift" }, "Return", -- Open backup terminal
        function()
            awful.spawn("urxvtc")
        end ),
	awful.key({ modkey, "Shift" }, "r",	-- Reload Awesome
		awesome.restart ),
	awful.key({ modkey, "Shift" }, "q",	-- Quit Awesome
		awesome.quit ),
	

	-- Layout Manipulation
	awful.key({ modkey,	      }, "l",	-- Increase Master Width Factor
		function ()
			awful.tag.incmwfact( 0.05)
		end ),
	awful.key({ modkey,	      }, "h",	-- Decrease Master Width Factor
		function ()
			awful.tag.incmwfact(-0.05)
		end ),
	awful.key({ modkey, "Shift"   }, "h",	-- Increase the number of Master Clients
		function ()
			awful.tag.incnmaster( 1, nil, true)
		end ),
	awful.key({ modkey, "Shift"   }, "l",	-- Decrease the number of Master Clients
		function ()
			awful.tag.incnmaster(-1, nil, true)
		end ),
	awful.key({ modkey, "Control" }, "h",	-- Increase the number of Columns
		function ()
			awful.tag.incncol( 1, nil, true)
		end ),
	awful.key({ modkey, "Control" }, "l",	-- Decrease the number of Columns
		function ()
			awful.tag.incncol(-1, nil, true)
		end ),
	awful.key({ modkey,	      }, "space",	-- Select next Layout
		function ()
			awful.layout.inc( 1)
		end ),
	awful.key({ modkey, "Shift"   }, "space",	-- Select Previous Layout
		function ()
			awful.layout.inc(-1)
		end ),
	
	awful.key({ modkey, "Control" }, "n",	-- Restore Minimized Client
		function ()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal(
				"request::activate", "key.unminimize",
				{raise = true} )
			end
		end ),
	
	-- Prompts/Launchers
	awful.key({ modkey }, "r",	-- DMenu, used as a "Run" prompt
		function()
			awful.spawn("bemenu-run --tf '#00ffff' --tb '#000044' --hf '#ffffff' --hb '#0000cc' --fn 'Monospace 16'")
		end )
)

clientkeys = gears.table.join(
	awful.key({ modkey,	      }, "f",	-- Toggle Fullscreen
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end ),
	awful.key({ modkey, "Shift"   }, "c",	-- Close Client
		function (c)
			c:kill()
		end ),
	awful.key({ modkey, "Control" }, "space",	-- Toggle Floating Mode on Client
		awful.client.floating.toggle ),
	awful.key({ modkey, "Control" }, "Return",	-- Move Focused Client to Master
		function (c)
			c:swap(awful.client.getmaster())
		end ),
	awful.key({ modkey,	      }, "o",	-- Move Focused Client's Screen
		function (c)
			c:move_to_screen()
		end ),
	awful.key({ modkey,	      }, "t",	-- Toggle Titlebar on Focused Client
		function (c)
			if c.border_width == 2 then
				awful.titlebar.hide(c)
				c.border_width = 0
				titlebar_on = false
			else
				awful.titlebar.show(c)
				c.border_width = 2
				titlebar_on = true
			end
		end ),
	awful.key({ modkey,	      }, "n",	-- Minimize Focused Client
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end ),
	awful.key({ modkey,	      }, "m", -- Toggle Maximize on Focused Client
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end ),
	awful.key({ modkey, "Control" }, "m",	-- Toggle Vertical Maximize on Client
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end ),
	awful.key({ modkey, "Shift"   }, "m",	-- Toggle Horizontal Maximize on Client
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		awful.key({ modkey }, "#" .. i + 9,	-- Only View Selected Tag
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end ),
		awful.key({ modkey, "Control" }, "#" .. i + 9,	-- Toggle Display of Selected Tag
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end ),
		awful.key({ modkey, "Shift" }, "#" .. i + 9,	-- Move Focused Client to Selected Tag
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end ),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,	-- Toggle Focused Client on Selected Tag
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end )
	)
end

clientbuttons = gears.table.join(
	awful.button({ }, 1,
		function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
		end ),
	awful.button({ modkey }, 1,
		function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.move(c)
		end ),
	awful.button({ modkey }, 3,
	function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.resize(c)
	end )
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- Rules {{{

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = { border_width = beautiful.border_width,
		border_color = beautiful.border_normal,
		focus = awful.client.focus.filter,
		raise = true,
		keys = clientkeys,
		buttons = clientbuttons,
		screen = awful.screen.preferred,
		placement = awful.placement.no_overlap+awful.placement.no_offscreen }
	},
	
	-- Floating clients.
	{
		rule_any = {
		instance = {
			"DTA",	-- Firefox addon DownThemAll.
			"copyq",  -- Includes session name in class.
			"pinentry"
		},
		class = {
			"Arandr",
			"Blueman-manager",
			"Gpick",
			"Kruler",
			"MessageWin",  -- kalarm.
			"Sxiv",
			"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			"Wpa_gui",
			"veromix",
			"xtightvncviewer",
			"Godot_Engine"
		},
		
		-- Note that the name property shown in xprop might be set slightly after creation of the client
		-- and the name shown there might not match defined rules here.
		name = {
			"Event Tester",  -- xev.
		},
		role = {
			"AlarmWindow",	-- Thunderbird's calendar.
			"ConfigManager",  -- Thunderbird's about:config.
			"pop-up",	-- e.g. Google Chrome's (detached) Developer Tools. 
		} },
		properties = { floating = true } },

	-- Add titlebars to normal clients and dialogs
	{	rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = false } },

	{	rule_any = { class = { "Xterm", "URxvt", "Emacs" } },
		properties = { size_hints_honor = false } },

    {   rule_any = { class = { "BorderlandsPreSequel" } },
        properties = { floating = true } }
}

-- }}}

-- Signals {{{

-- Signal function to execute when a new client appears.
client.connect_signal("manage",
	function (c)
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- if not awesome.startup then awful.client.setslave(c) end
		if awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position then
			-- Prevent clients from being unreachable after screen count changes.
			awful.placement.no_offscreen(c)
		end
	end )

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars",
	function(c)
		-- buttons for the titlebar
		local buttons = gears.table.join(
		awful.button({ }, 1, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.move(c)
		end ),
		awful.button({ }, 3,
			function()
				c:emit_signal("request::activate", "titlebar", { raise = true })
				awful.mouse.client.resize(c)
			end ) )
	awful.titlebar(c) : setup {
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout	= wibox.layout.fixed.horizontal
		},
	{ -- Middle
		{ -- Title
			align  = "center",
			widget = awful.titlebar.widget.titlewidget(c)
		},
		buttons = buttons,
		layout	= wibox.layout.flex.horizontal
	},
	{ -- Right
		awful.titlebar.widget.floatingbutton (c),
		awful.titlebar.widget.maximizedbutton(c),
		awful.titlebar.widget.stickybutton   (c),
		awful.titlebar.widget.ontopbutton    (c),
		awful.titlebar.widget.closebutton    (c),
		layout = wibox.layout.fixed.horizontal()
	},
	layout = wibox.layout.align.horizontal }
end )

-- kinda dynamic borders
client.connect_signal("focus",
	function(c)
		c.border_color = beautiful.border_focus
	end )
client.connect_signal("unfocus",
	function(c)
		c.border_color = beautiful.border_normal
	end )
-- }}}
