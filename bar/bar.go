package bar

import (
	"github.com/diamondburned/gotk4-layer-shell/pkg/gtk4layershell"
	"github.com/diamondburned/gotk4/pkg/gdk/v4"
	"github.com/diamondburned/gotk4/pkg/gtk/v4"
	"github.com/xitonight/mactoshell/modules"
)

type Bar struct {
	*gtk.Window
}

func NewBar(monitor *gdk.Monitor) *Bar {
	w := gtk.NewWindow()
	bar := &Bar{Window: w}

	gtk4layershell.InitForWindow(w)
	gtk4layershell.SetMonitor(w, monitor)
	gtk4layershell.SetLayer(w, gtk4layershell.LayerTop)
	gtk4layershell.SetAnchor(w, gtk4layershell.LayerShellEdgeTop, true)
	gtk4layershell.SetAnchor(w, gtk4layershell.LayerShellEdgeLeft, true)
	gtk4layershell.SetAnchor(w, gtk4layershell.LayerShellEdgeRight, true)
	gtk4layershell.SetExclusiveZone(w, 36)

	w.SetDefaultSize(1, 36)

	root := gtk.NewBox(gtk.OrientationHorizontal, 12)
	root.AddCSSClass("bar")
	root.SetMarginStart(8)
	root.SetMarginEnd(8)

	brand := gtk.NewLabel("mactoshell")
	brand.AddCSSClass("label-brand")

	clock := modules.NewClock()

	spacer := gtk.NewBox(gtk.OrientationHorizontal, 0)
	spacer.AddCSSClass("spacer")
	spacer.SetHExpand(true)

	placeholder := gtk.NewLabel("modules")
	placeholder.AddCSSClass("label-subtle")

	root.Append(brand)
	root.Append(clock)
	root.Append(spacer)
	root.Append(placeholder)

	w.SetChild(root)
	return bar
}
