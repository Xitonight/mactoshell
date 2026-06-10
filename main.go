package main

import (
	"os"

	"github.com/diamondburned/gotk4/pkg/gdk/v4"
	"github.com/diamondburned/gotk4/pkg/gtk/v4"
	"github.com/xitonight/mactoshell/bar"
	"github.com/xitonight/mactoshell/theme"
)

func main() {
	app := gtk.NewApplication("com.github.xitonight.mactoshell", 0)
	app.ConnectActivate(func() {
		cssProvider := gtk.NewCSSProvider()
		cssProvider.LoadFromString(theme.CSS)
		gtk.StyleContextAddProviderForDisplay(
			gdk.DisplayGetDefault(),
			cssProvider,
			gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
		)

		display := gdk.DisplayGetDefault()
		monitors := display.Monitors()

		for i := uint(0); i < monitors.NItems(); i++ {
			mon := monitors.Item(i)
			monitor, ok := mon.Cast().(*gdk.Monitor)
			if !ok {
				continue
			}
			b := bar.NewBar(monitor)
			app.AddWindow(b.Window)
			b.SetVisible(true)
		}
	})

	code := app.Run(os.Args)
	if code > 0 {
		os.Exit(code)
	}
}
