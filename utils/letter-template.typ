#import "@preview/fontawesome:0.6.0": *
#import "@preview/catppuccin:1.0.0": catppuccin
#import "./injection.typ": inject
#import "helper.typ": *

/// Cover letter template that is inspired by the Awesome CV Latex template by posquit0. This template can loosely be considered a port of the original Latex template.
/// This coverletter template is designed to be used with the resume template.
/// - author (dictionary): Structure that takes in all the author's information. The following fields are required: firstname, lastname, positions. The following fields are used if available: email, phone, github, linkedin, orcid, address, website, custom. The `custom` field is an array of additional entries with the following fields: text (string, required), icon (string, optional Font Awesome icon name), link (string, optional).
/// - profile-picture (image): The profile picture of the author. This will be cropped to a circle and should be square in nature.
/// - date (datetime): The date the cover letter was created. This will default to the current date.
/// - accent-colour (colour): The accent colour of the cover letter
/// - language (string): The language of the cover letter, defaults to "en". See lang.toml for available languages
/// - font (array): The font families of the cover letter
/// - header-font (array): The font families of the cover letter header
/// - show-footer (boolean): Whether to show the footer or not
/// - closing (content): The closing of the cover letter. This defaults to "Attached Curriculum Vitae". You can set this to `none` to show the default closing or remove it completely.
/// - use-smallcaps (boolean): Whether to use small caps formatting throughout the template
/// - show-address-icon (boolean): Whether to show the address icon
/// - description (str | none): The PDF description
/// - keywords (array | str): The PDF keywords
/// - body (content): The body of the cover letter
#let coverletter(
  date: datetime.today().display("[day] [month repr:long] [year]"),
  accent-colour: default-accent-colour,
  show-footer: true,
  sincerely: "Sincerely",
  closing: none,
  paper-size: "a4",
  use-smallcaps: true,
  show-address-icon: false,
  description: none,
  keywords: (),
  body,
) = {
  let author = data.author

  show: catppuccin.with(flavour)

  if type(accent-colour) == str {
    accent-colour = rgb(accent-colour)
  }

  if closing == none {
    closing = data.curriculum-vitae
  }

  let desc = if description == none {
    lflib._linguify("cover-letter", lang: language, from: lang_data).ok + " " + author.firstname + " " + author.lastname
  } else {
    description
  }

  show: body => context {
    set document(
      author: author.firstname + " " + author.lastname,
      title: data.coverletter,
      description: desc,
      keywords: keywords,
    )
    body
  }

  set text(
    font: font,
    lang: language,
    size: 11pt,
    fill: colour-text,
    fallback: true,
  )

  set page(
    paper: paper-size,
    margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
    footer: if show-footer [#coverletter_footer(
        author,
        language,
        date,
        use-smallcaps: use-smallcaps,
      )] else [],
    footer-descent: 2mm,
  )

  // set paragraph spacing
  set par(spacing: 0.75em, justify: true)

  set heading(numbering: none, outlined: false)

  show heading: it => [
    #set block(above: 1em, below: 1em)
    #set text(size: 16pt, weight: "regular")

    #align(left)[
      #text[#strong[#text(accent-colour)[#it.body]]]
      #box(width: 1fr, line(length: 100%, stroke: default-accent-colour))
    ]
  ]

  let name = {
    align(right)[
      #pad(bottom: 5pt)[
        #block[
          #set text(size: 32pt, style: "normal", font: header-font)
          #text(accent-colour, weight: "thin")[#author.firstname]
          #text(weight: "bold")[#author.lastname]
        ]
      ]
    ]
  }

  let positions = {
    set text(accent-colour, size: 9pt, weight: "regular")
    align(right)[
      #apply_smallcaps(
        author.positions.join(text[#"  "#sym.dot.c#"  "]),
        use-smallcaps,
      )
    ]
  }

  let address = {
    set text(size: 9pt, weight: "bold", fill: colour-subtitle)
    align(right)[
      #if ("address" in author) [
        #if show-address-icon [
          #address-icon
          #box[#text(author.address)]
        ] else [
          #text(author.address)
        ]
      ]
    ]
  }

  let contacts = {
    set box(height: 9pt)

    let separator = [ #box(sym.bar.v) ]
    let author_list = ()

    if ("phone" in author) {
      author_list.push[
        #phone-icon~#box[#link("tel:" + author.phone)[#author.phone]]
      ]
    }
    if ("email" in author) {
      author_list.push[
        #email-icon~#box[#link("mailto:" + author.email)[#author.email]]
      ]
    }
    if ("github" in author) {
      author_list.push[
        #github-icon~#box[#link("https://github.com/" + author.github)[#author.github]]
      ]
    }
    if ("linkedin" in author) {
      author_list.push[
        #linkedin-icon~#box[
          #link("https://www.linkedin.com/in/" + author.linkedin)[#author.firstname #author.lastname]
        ]
      ]
    }
    if ("orcid" in author) {
      author_list.push[
        #orcid-icon~#box[#link("https://orcid.org/" + author.orcid)[#author.orcid]]
      ]
    }
    if ("website" in author) {
      author_list.push[
        #website-icon~#box[#link(author.website)[#author.website]]
      ]
    }

    if ("custom" in author and type(author.custom) == array) {
      for item in author.custom {
        if ("text" in item) {
          author_list.push[
            #if ("icon" in item) [
              #box(fa-icon(item.icon, fill: colour-darknight))
            ]
            #box[
              #if ("link" in item) [
                #link(item.link)[#item.text]
              ] else [
                #item.text
              ]
            ]
          ]
        }
      }
    }


    align(right)[
      #set text(size: 8pt, weight: "light", style: "normal")
      #author_list.join(separator)
    ]
  }

  let letter-heading = {
    grid(
      columns: (1fr, 2fr),
      rows: 100pt,
      align(left + horizon)[
        #block(
          clip: true,
          stroke: 0pt,
          radius: 2cm,
          width: 4cm,
          height: auto,
          image("../assets/" + author.profile-picture),
        )
      ],
      [
        #name
        #positions
        #address
        #contacts
      ],
    )
  }

  let signature = {
    align(bottom)[
      #pad(bottom: 2em)[
        #text(weight: "light")[#sincerely] \
        #text(weight: "bold")[#author.firstname #author.lastname] \ \
      ]
    ]
  }

  // actual content
  letter-heading
  body
  linebreak()
  signature
  closing
}

/// Cover letter heading that takes in the information for the hiring company and formats it properly.
/// - entity-info (content): The information of the hiring entity including the company name, the target (who's attention to), street address, and city
/// - date (date): The date the letter was written (defaults to the current date)
#let hiring-entity-info(
  entity-info: (:),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
  use-smallcaps: true,
) = {
  set par(leading: 1em)
  pad(top: 1.5em, bottom: 1.5em)[
    #justify_align[
      #text(weight: "bold", size: 12pt)[#entity-info.target]
    ][
      #text(weight: "light", style: "italic", size: 9pt)[#date]
    ]

    #pad(top: 0.65em, bottom: 0.65em)[
      #text(weight: "regular", fill: colour-subtitle, size: 9pt)[
        #apply_smallcaps(entity-info.name, use-smallcaps) \
        #entity-info.street-address \
        #entity-info.city \
      ]
    ]
  ]
}

/// Letter heading for a given job position and addressee.
/// - job-position (string): The job position you are applying for
/// - addressee (string): The person you are addressing the letter to
/// - dear (string): optional field for redefining the "dear" variable
#let letter-heading(job-position: "", addressee: "", dear: "") = {

  // TODO: Make this adaptable to content
  underline(evade: false, stroke: 0.5pt, offset: 0.3em)[
    #text(weight: "bold", size: 12pt)[#job-position]
  ]
  pad(top: 1em, bottom: 1em)[
    #text(weight: "light", fill: colour-subtitle)[
      #dear
      #addressee,
    ]
  ]
}

/// Cover letter content paragraph. This is the main content of the cover letter.
/// - content (content): The content of the cover letter
#let coverletter-content(content) = {
  pad(top: 1em, bottom: 1em)[
    #set par(first-line-indent: 3em)
    #set text(weight: "light")
    #content
  ]
}

/// ---- End of Coverletter ----