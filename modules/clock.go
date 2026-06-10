package modules

import (
	"time"

	"github.com/diamondburned/gotk4/pkg/glib/v2"
	"github.com/diamondburned/gotk4/pkg/gtk/v4"
)

type Clock struct {
	*gtk.Label
}

func NewClock() *Clock {
	lbl := gtk.NewLabel("")
	lbl.AddCSSClass("label-subtle")
	lbl.SetName("clock")

	c := &Clock{Label: lbl}
	c.update()
	go c.tick()
	return c
}

func (c *Clock) update() {
	now := time.Now()
	c.Label.SetLabel(now.Format("Jan 2  15:04"))
}

func (c *Clock) tick() {
	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()
	for range ticker.C {
		glib.IdleAdd(func() bool {
			c.update()
			return false
		})
	}
}
