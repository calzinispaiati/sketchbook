Goal: to draw a single image, tint it three ways, rotate it three ways, and
blend it onto Processing's main canvas, creating a shifting mess of colorful
bubbles.

I'm only drawing one moving image, but you see three copies, one each in red,
blue, and gree. The rotations are what make it look like the objects are all
moving different directions.

Result:

![bubble colors](http://dl.dropbox.com/u/3147390/pics/2011-11-12-20-49-45_screen_shot_2011-11-12_at_8.49.39_pm.png)

In motion: [bubble color movie on Vimeo](http://vimeo.com/32021052).

Processing doesn't have javascript's [globalCompositeOperation](https://developer.mozilla.org/samples/canvas-tutorial/6_1_canvas_composite.html),
so I'm faking it.
