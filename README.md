# Spirit Rend
My entry for [Godot Wild Jam #39](https://godotwildjam.com)

This was the first game jam that I was able to actually make something in, and despite the long jam duration I was barely able to end up with a prototype.

That said, I've gained an enormous amount of experience while making it and I'm very confident that I'll be able to get things done much faster than I used to.

I mean, before I joined this jam I couldn't even make a single grid map with a consistent look, but for the jam alone I was able to make 3 separate sets of wall tiles that actually worked.

In addition to the Godot project itself I've also included the raw Krita, Photoshop and Blender files I used to make the assets.

## Jam Theme
The theme of the jam was **inversion**, so I decided to make a game where the effects of damage and healing would be reversed at intervals that got shorter over time. I retrofitted this mechanic into the story by imagining a daimyo (aka feudal lord) who came up with a device that could reverse the effects of yin and yang.

## What's Missing
- HTML5 export OR Windows/Linux/MacOS exports
    - I don't have a Linux machine, and I can't produce exports on my Mac because of an Apple Developer Program issue
    - The game does export to HTML5 but its performance is very bad. Optimization is not something I've been able to explore previously, but I believe the main culprits are instanced scatter items that I "scattered" around.
- Modeling, rigging, and animating the following characters:
    - Player
    - Disciple (sword enemy)
    - Scout (archer enemy)
    - Oaf (hammer enemy)
    - Monk (healer enemy)
    - Daimyo (boss)
- Modeling the barracks building
- Modeling and animate the Spirit Rend device
- Implementing boss logic
- Implementing interstitials (e.g. story text displayed before and after the game)
- Adding SFX and music
- General polish

## License
MIT
