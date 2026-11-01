package main

import (
	"log"

	"github.com/fogleman/gg"
)

//	"github.com/golang/freetype/truetype"
//	"golang.org/x/image/font/gofont/goregular"

func main() {

	log.Print("Start ...")

	// Load your source image
	// im, err := gg.LoadImage("page.jpg")
	// if err != nil {
	// 	log.Fatalf("failed to load image: %v", err)
	// }

	// Create a drawing context from the image
	// bounds := im.Bounds()
	// dc := gg.NewContext(bounds.Dx(), bounds.Dy())
	// dc.DrawImage(im, 0, 0)
	dc := gg.NewContext(1000, 1000)
	// Set text color (white)
	dc.SetRGB(1, 1, 1)
	dc.Clear()
	log.Print("... clear white")
	// dc.DrawCircle(500, 500, 400)
	// dc.SetRGB(0, 0, 0) // Setze Farbe auf Schwarz
	// dc.Fill()
	dc.SetRGB(0, 0, 0) // Setze Farbe auf Schwarz
	for i := 1; i < 10; i++ {
		dc.DrawPoint(float64(50*i), float64(50*i), 5)
	}
	dc.Fill()

	log.Print("... load TTF")
	// Load a TTF font file and set size
	// if err := dc.LoadFontFace("arial.ttf", 48); err != nil {
	if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 64); err != nil {
		log.Fatalf("failed to load font: %v", err)
	}
	//	font, err := truetype.Parse(goregular.TTF)
	//	if err != nil {
	//		log.Fatal(err)
	//	}
	//	face := truetype.NewFace(font, &truetype.Options{Size: 24})
	//	dc.SetFontFace(face)

	// Draw anchored text in the middle of the image
	// x := float64(bounds.Dx()) / 2
	// y := float64(bounds.Dy()) / 2
	// dc.DrawStringAnchored("Hello, Go!", x, y, 80.5, 80.5)
	dc.DrawStringAnchored("Hello, Go!", 500, 500, 0.5, 0.5)

	// Save the resulting image
	if err := dc.SavePNG("output.png"); err != nil {
		log.Fatalf("failed to save image: %v", err)
	}

	log.Print("... Done")
}
