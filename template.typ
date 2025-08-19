#import "@preview/fontawesome:0.5.0": *
#import "@preview/linguify:0.4.2": *
#import "@preview/catppuccin:1.0.0": catppuccin, flavors, get-flavor
#import "utils/injection.typ": inject

#let data = toml("./data.toml")
#let language = data.language

// const color
#let flavor = get-flavor(data.theme)
#let accent = data.accent

#let palette = flavor.colors
#let color-darknight = palette.text.rgb // rgb("#131A28")
#let color-darkgray = palette.subtext0.rgb // rgb("#333333")
#let color-gray = palette.subtext1.rgb // rgb("#5d5d5d")
#let default-accent-color = palette.at(accent).rgb // rgb("#262F99")
#let default-location-color = palette.subtext0.rgb //rgb("#333333")

// const font
#let font = data.text-font
#let header-font = data.header-font

// const icons
#let icon-colour = default-accent-color
#let linkedin-icon = box(fa-icon("linkedin", fill: icon-colour))
#let github-icon = box(fa-icon("github", fill: icon-colour))
#let gitlab-icon = box(fa-icon("gitlab", fill: icon-colour))
#let bitbucket-icon = box(fa-icon("bitbucket", fill: icon-colour))
#let twitter-icon = box(fa-icon("twitter", fill: icon-colour))
#let google-scholar-icon = box(fa-icon("google-scholar", fill: icon-colour))
#let orcid-icon = box(fa-icon("orcid", fill: icon-colour))
#let phone-icon = box(fa-icon("square-phone", fill: icon-colour))
#let email-icon = box(fa-icon("envelope", fill: icon-colour))
#let birth-icon = box(fa-icon("cake", fill: icon-colour))
#let homepage-icon = box(fa-icon("home", fill: icon-colour))
#let website-icon = box(fa-icon("globe", fill: icon-colour))
#let address-icon = box(fa-icon("location-pin", fill: icon-colour))

/// Helpers
/// 

// Common helper functions
#let __format_author_name(author, language) = {
  if language == "zh" or language == "ja" {
    str(author.firstname) + str(author.lastname)
  } else {
    str(author.firstname) + " " + str(author.lastname)
  }
}

#let __apply_smallcaps(content, use-smallcaps) = {
  if use-smallcaps {
    smallcaps(content)
  } else {
    content
  }
}

// layout utility
#let __justify_align(left_body, right_body) = {
  block[
    #left_body
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let __justify_align_3(left_body, mid_body, right_body) = {
  block[
    #box(width: 1fr)[
      #align(left)[
        #left_body
      ]
    ]
    #box(width: 1fr)[
      #align(center)[
        #mid_body
      ]
    ]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let __coverletter_footer(
  author,
  language,
  date,
  lang_data,
  use-smallcaps: true,
) = {
  set text(fill: gray, size: 8pt)
  __justify_align_3[
    #__apply_smallcaps(date, use-smallcaps)
  ][
    #__apply_smallcaps(
      {
        let name = __format_author_name(author, language)
        name + " · " + linguify("cover-letter", from: lang_data)
      },
      use-smallcaps,
    )
  ][
    #context {
      counter(page).display()
    }
  ]
}

#let __resume_footer(author, language, lang_data, date, use-smallcaps: true) = {
  set text(fill: gray, size: 8pt)
  __justify_align_3[
    #__apply_smallcaps(date, use-smallcaps)
  ][
    #__apply_smallcaps(
      {
        let name = __format_author_name(author, language)
        name + " · " + linguify("resume", from: lang_data)
      },
      use-smallcaps,
    )
  ][
    #context {
      counter(page).display()
    }
  ]
}

/// Show a link with an icon, specifically for Github projects
/// *Example*
/// #example(`resume.github-link("DeveloperPaul123/awesome-resume")`)
/// - github-path (string): The path to the Github project (e.g. "DeveloperPaul123/awesome-resume")
/// -> none
#let github-link(github-path) = {
  set box(height: 11pt)

  align(right + horizon)[
    #fa-icon("github", fill: color-darkgray) #link(
      "https://github.com/" + github-path,
      github-path,
    )
  ]
}

/// Right section for the justified headers
/// - body (content): The body of the right header
#let secondary-right-header(body) = {
  set text(size: 11pt, weight: "medium")
  body
}

/// Right section of a tertiaty headers.
/// - body (content): The body of the right header
#let tertiary-right-header(body) = {
  set text(weight: "light", size: 9pt)
  body
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let justified-header(primary, secondary) = {
  set block(above: 0.7em, below: 0.7em)
  pad[
    #__justify_align[
      == #primary
    ][
      #secondary-right-header[#secondary]
    ]
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right. This is a smaller header compared to the `justified-header`.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let secondary-justified-header(primary, secondary) = {
  __justify_align[
    === #primary
  ][
    #tertiary-right-header[#secondary]
  ]
}
/// --- End of Helpers

/// ---- Resume Template ----

/// Resume template that is inspired by the Awesome CV Latex template by posquit0. This template can loosely be considered a port of the original Latex template.
///
/// The original template: https://github.com/posquit0/Awesome-CV
///
/// - profile-picture (image): The profile picture of the author. This will be cropped to a circle and should be square in nature.
/// - date (string): The date the resume was created
/// - accent-color (color): The accent color of the resume
/// - colored-headers (boolean): Whether the headers should be colored or not
/// - language (string): The language of the resume, defaults to "en". See lang.toml for available languages
/// - use-smallcaps (boolean): Whether to use small caps formatting throughout the template
/// - show-address-icon (boolean): Whether to show the address icon
/// - description (str | none): The PDF description
/// - keywords (array | str): The PDF keywords
/// - inject_ai (boolean): Whether to inject an AI prompt
/// - body (content): The body of the resume
/// -> none
#let resume(
  accent-color: default-accent-color,
  date: datetime.today().display("[day]. [month repr:long] [year]"),
  use-smallcaps: true,
  show-address-icon: true,
  colored-headers: true,
  show-footer: true,
  paper-size: "a4",
  description: none,
  keywords: ("Engineer", "Architect"),
  inject_ai: true,
  body,
) = {
  let author = data.author

  show: catppuccin.with(flavor)
  if type(accent-color) == str {
    accent-color = rgb(accent-color)
  }

  let lang_data = toml("lang.toml")

  let desc = if description == none {
    lflib._linguify("resume", lang: language, from: lang_data).ok + " " + author.firstname + " " + author.lastname
  } else {
    description
  }

  show: body => context {
    set document(
      author: author.firstname + " " + author.lastname,
      title: lflib._linguify("resume", lang: language, from: lang_data).ok,
      description: desc,
      keywords: keywords,
    )
    body
  }

  set text(
    font: font,
    lang: language,
    size: 11pt,
    fill: color-darkgray,
    fallback: true,
  )

  set page(
    paper: paper-size,
    margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
    footer: if show-footer [#__resume_footer(
        author,
        language,
        lang_data,
        date,
        use-smallcaps: use-smallcaps,
      )] else [],
    footer-descent: 0pt,
  )

  inject(
    if_inject_ai_prompt: inject_ai,
    if_inject_keywords: inject_ai,
    keywords_list: keywords,
  )

  // set paragraph spacing
  set par(spacing: 0.75em, justify: true)

  set heading(numbering: none, outlined: false)

  show heading.where(level: 1): it => [
    #set text(size: 16pt, weight: "regular", font: header-font)
    #set align(left)
    #set block(above: 1em)
    #let color = if colored-headers {
      accent-color
    } else {
      color-darkgray
    }
    #text(fill: color, weight: "bold")[#__apply_smallcaps(it.body, use-smallcaps)]
    #box(width: 1fr, line(length: 100%, stroke: color-darknight))
  ]

  show heading.where(level: 2): it => {
    set text(color-darkgray, size: 12pt, style: "normal", weight: "bold")
    it.body
  }

  show heading.where(level: 3): it => {
    set text(size: 10pt, weight: "regular")
    __apply_smallcaps(it.body, use-smallcaps)
  }

  let name = {
    align(center)[
      #pad(bottom: 5pt)[
        #block[
          #set text(size: 32pt, style: "normal", font: header-font)
          #if language == "zh" or language == "ja" [
            #text(accent-color, weight: "thin")[#author.firstname]#text(weight: "bold")[#author.lastname]
          ] else [
            #text(accent-color, weight: "thin")[#author.firstname]
            #text(weight: "bold")[#author.lastname]
          ]
        ]
      ]
    ]
  }

  let positions = {
    set text(accent-color, size: 9pt, weight: "regular")
    align(center)[
      #__apply_smallcaps(
        author.positions.join(text[#"  "#sym.dot.c#"  "]),
        use-smallcaps,
      )
    ]
  }

  let address = {
    set text(size: 9pt, weight: "regular")
    align(center)[
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

    let separator = box(width: 5pt)

    align(center)[
      #set text(size: 9pt, weight: "regular", style: "normal")
      #block[
        #align(horizon)[
          #if ("birth" in author) [
            #birth-icon~#box[#text(author.birth)]
            #separator
          ]
          #if ("phone" in author) [
            #phone-icon~#box[#link("tel:" + author.phone)[#author.phone]]
            #separator
          ]
          #if ("email" in author) [
            #email-icon~#box[#link("mailto:" + author.email)[#author.email]]
          ]
          #if ("homepage" in author) [
            #separator
            #homepage-icon~#box[#link(author.homepage)[#author.homepage]]
          ]
          #if ("github" in author) [
            #separator
            #github-icon~#box[#link("https://github.com/" + author.github)[#author.github]]
          ]
          #if ("gitlab" in author) [
            #separator
            #gitlab-icon~#box[#link("https://gitlab.com/" + author.gitlab)[#author.gitlab]]
          ]
          #if ("bitbucket" in author) [
            #separator
            #bitbucket-icon~#box[#link("https://bitbucket.org/" + author.bitbucket)[#author.bitbucket]]
          ]
          #if ("linkedin" in author) [
            #separator
            #linkedin-icon~#box[
              #link("https://www.linkedin.com/in/" + author.linkedin)[#author.firstname #author.lastname]
            ]
          ]
          #if ("twitter" in author) [
            #separator
            #twitter-icon~#box[#link("https://twitter.com/" + author.twitter)[\@#author.twitter]]
          ]
          #if ("scholar" in author) [
            #let fullname = str(author.firstname + " " + author.lastname)
            #separator
            #google-scholar-icon~#box[#link("https://scholar.google.com/citations?user=" + author.scholar)[#fullname]]
          ]
          #if ("orcid" in author) [
            #separator
            #orcid-icon~#box[#link("https://orcid.org/" + author.orcid)[#author.orcid]]
          ]
          #if ("website" in author) [
            #separator
            #website-icon~#box[#link(author.website)[#author.website]]
          ]
          #if ("custom" in author and type(author.custom) == array) [
            #for item in author.custom [
              #if ("text" in item) [
                #separator
                #if ("icon" in item) [
                  #box(fa-icon(item.icon, fill: color-darknight))
                ]
                #box[
                  #if ("link" in item) [
                    #link(item.link)[#item.text]
                  ] else [
                    #item.text
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  }

  if author.profile-picture != false {
    grid(
      columns: (100% - 4cm, 4cm),
      rows: 100pt,
      gutter: 10pt,
      [
        #name
        #positions
        #address
        #contacts
      ],
      align(left + horizon)[
        #block(
          clip: true,
          stroke: 0pt,
          radius: 2cm,
          width: 4cm,
          height: 4cm,
          image(author.profile-picture),
        )
      ],
    )
  } else {
    name
    positions
    address
    contacts
  }

  body
}

/// The base item for resume entries.
/// This formats the item for the resume entries. Typically your body would be a bullet list of items. Could be your responsibilities at a company or your academic achievements in an educational background section.
/// - body (content): The body of the resume entry
#let resume-item(body) = {
  set text(size: 10pt, style: "normal", weight: "light", fill: color-darknight)
  set block(above: 0.75em, below: 1.25em)
  set par(leading: 0.65em)
  block(above: 0.5em)[
    #body
  ]
}

/// The base item for resume entries. This formats the item for the resume entries. Typically your body would be a bullet list of items. Could be your responsibilities at a company or your academic achievements in an educational background section.
/// - title (string): The title of the resume entry
/// - location (string): The location of the resume entry
/// - date (string): The date of the resume entry, this can be a range (e.g. "Jan 2020 - Dec 2020")
/// - description (content): The body of the resume entry
/// - title-link (string): The link to use for the title (can be none)
/// - accent-color (color): Override the accent color of the resume-entry
/// - location-color (color): Override the default color of the "location" for a resume entry.
#let resume-entry(
  title: none,
  location: "",
  date: "",
  description: "",
  title-link: none,
  accent-color: default-accent-color,
  location-color: default-location-color,
) = {
  let title-content
  if type(title-link) == str {
    title-content = link(title-link)[#title]
  } else {
    title-content = title
  }
  block(above: 1em, below: 0.65em)[
    #pad[
      #justified-header(title-content, location)
      #if description != "" or date != "" [
        #secondary-justified-header(description, date)
      ]
    ]
  ]
}

/// Show cumulative GPA.
/// *Example:*
/// #example(`resume.resume-gpa("3.5", "4.0")`)
#let resume-gpa(numerator, denominator) = {
  set text(size: 12pt, style: "italic", weight: "light")
  text[Cumulative GPA: #box[#strong[#numerator] / #denominator]]
}

/// Show a certification in the resume.
/// *Example:*
/// #example(`resume.resume-certification("AWS Certified Solutions Architect - Associate", "Jan 2020")`)
/// - certification (content): The certification
/// - date (content): The date the certification was achieved
#let resume-certification(certification, date) = {
  justified-header(certification, date)
}

/// Styling for resume skill categories.
/// - category (string): The category
#let resume-skill-category(category) = {
  align(left)[
    #set text(hyphenate: false)
    == #category
  ]
}

/// Styling for resume skill values/items
/// - values (array): The skills to display
#let resume-skill-values(values) = {
  align(left)[
    #set text(size: 11pt, style: "normal", weight: "light")
    // This is a list so join by comma (,)
    #values.join(", ")
  ]
}

/// Show a list of skills in the resume under a given category.
/// - category (string): The category of the skills
/// - items (list): The list of skills. This can be a list of strings but you can also emphasize certain skills by using the `strong` function.
#let resume-skill-item(category, items) = {
  set block(below: 0.65em)
  set pad(top: 2pt)

  pad[
    #grid(
      columns: (3fr, 8fr),
      gutter: 10pt,
      resume-skill-category(category), resume-skill-values(items),
    )
  ]
}

/// Show a grid of skill lists with each row corresponding to a category of skills, followed by the skills themselves. The dictionary given to this function should have the skill categories as the dictionary keys and the values should be an array of values for the corresponding key.
/// - categories_with_values (dictionary): key value pairs of skill categories and it's corresponding values (skills)
#let resume-skill-grid(categories_with_values: (:)) = {
  set block(below: 1.25em)
  set pad(top: 2pt)

  pad[
    #grid(
      columns: (auto, auto),
      gutter: 10pt,
      ..categories_with_values
        .pairs()
        .map(((key, value)) => (
          resume-skill-category(key),
          resume-skill-values(value),
        ))
        .flatten()
    )
  ]
}