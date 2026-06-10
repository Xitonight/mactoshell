package theme

import (
	_ "embed"
	"log"
	"strings"

	"github.com/diamondburned/gotk4/pkg/gtk/v4"
)

//go:embed style.css
var CSS string

func LoadCSS() *gtk.CSSProvider {
	prov := gtk.NewCSSProvider()
	prov.ConnectParsingError(func(sec *gtk.CSSSection, err error) {
		// Optional line parsing routine.
		loc := sec.StartLocation()
		lines := strings.Split(CSS, "\n")
		log.Printf("CSS error (%v) at line: %q", err, lines[loc.Lines()])
	})
	prov.LoadFromString(CSS)
	return prov
}
