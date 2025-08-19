#import "template.typ": *

#show: resume.with()

= TODO
#show enum.item: it => {
  if repr(it.body).contains("X") { 
    strike(stroke: red)[#it]
  }
  else { it }
}

+ AwesomeFont downloaden für Symbole
+ Bessere Symbole
+ Inject AI Prompt X
+ Liste an Stuff unter Adresse besser sortieren
+ Geschützte Leerzeichen o. Ä. X
+ Platz zwischen Namen und Keywords
+ Lang.toml ausmerzen
+ Footer anpassen
+ Funktionen aufräumen
+ Punkte und Nummern einfärben #v(1em)
+ Ausfüllen

#repeat("_")
#v(1em)
+ Coverletter bearbeiten

= Education

#resume-entry(
  title: "Example University",
  location: "Example City, EX",
  date: "August 2014 - May 2019",
  description: "B.S. in Computer Science",
)

#resume-item[
  - #lorem(20)
  - #lorem(15)
  - #lorem(25)
]

= Skills

#resume-skill-item(
  "Programming Languages",
  (
    strong("C++"),
    strong("Python"),
    "Rust",
    "Java",
    "C#",
    "JavaScript",
    "TypeScript",
  ),
)
#resume-skill-item("Spoken Languages", (strong("English"), "Spanish"))
#resume-skill-item(
  "Programs",
  (
    strong("Excel"),
    "Word",
    "Powerpoint",
    "Visual Studio",
  ),
)

#v(1em)
// An alternative way of list out your resume skills
#resume-skill-grid(
  categories_with_values: (
    "Programming Languages": (
      strong("C++"),
      strong("Python"),
      "Rust",
      "Java",
      "C#",
      "JavaScript",
      "TypeScript",
    ),
    "Spoken Languages": (
      strong("English"),
      "Spanish",
      "Greek",
    ),
    "Programs": (
      strong("Excel"),
      "Word",
      "Powerpoint",
      "Visual Studio",
      "git",
      "Zed"
    ),
    "Really Really Long Long Long Category": (
      "Thing 1",
      "Thing 2",
      "Thing 3"
    )
  ),
)