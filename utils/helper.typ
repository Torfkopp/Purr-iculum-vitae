#import "@preview/fontawesome:0.6.0": *
#import "@preview/catppuccin:1.0.0": catppuccin, get-flavor as get-flavour

#let data = toml("../settings.toml")
#let language = data.language
#let curriculum-vitae = data.curriculum-vitae

// const colour
#let flavour = get-flavour(data.theme)
#let accent = data.accent

#let palette = flavour.colors
#let colour-title = palette.text.rgb
#let colour-subtitle = palette.subtext1.rgb
#let colour-text = palette.text.rgb
#let default-accent-colour = palette.at(accent).rgb
#let default-location-colour = yellow //palette.subtext0.rgb

// const font
#let font = data.text-font
#let header-font = data.header-font

// const icons
#let icon-colour = default-accent-colour
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

#let apply_smallcaps(content, use-smallcaps) = {
  if use-smallcaps {
    smallcaps(content)
  } else {
    content
  }
}

#let justify_align(left_body, right_body) = {
  block[
    #left_body
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let justify_align_3(left_body, mid_body, right_body) = {
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

#let resume_footer(author, language, date, use-smallcaps: true) = {
  set text(fill: colour-text, size: 8pt)
  justify_align[
    #apply_smallcaps(date, use-smallcaps)
  ][
    #apply_smallcaps(
      {
        let name = str(author.firstname + " " + author.lastname)
        name + " · " + curriculum-vitae
      },
      use-smallcaps,
    )
  ]
  // [
  //   #context {
  //     counter(page).display()
  //   }
  // ]
}

/// Show a link with an icon, specifically for Github projects
/// *Example*
/// #example(`resume.github-link("DeveloperPaul123/awesome-resume")`)
/// - github-path (string): The path to the Github project (e.g. "DeveloperPaul123/awesome-resume")
/// -> none
#let github-link(github-path) = {
  set box(height: 11pt)

  align(right + horizon)[
    #fa-icon("github", fill: default-accent-colour) #link(
      "https://github.com/" + github-path,
      github-path,
    )
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let justified-header(primary, secondary) = {
  set block(above: 0.7em, below: 0.7em)
  pad[
    #justify_align[
      == #primary
    ][
      #set text(size: 11pt, weight: "medium", fill: colour-title)
      #secondary
    ]
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right. This is a smaller header compared to the `justified-header`.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let secondary-justified-header(primary, secondary) = {
  justify_align[
    #set text(fill: colour-subtitle)
    === #primary
  ][
    #set text(weight: "light", size: 9pt, fill: colour-subtitle)
    #secondary
  ]
}

#let coverletter_footer(
  author,
  language,
  date,
  use-smallcaps: true,
) = {
  set text(fill: gray, size: 8pt)
  justify_align_3[
    #apply_smallcaps(date, use-smallcaps)
  ][
    #apply_smallcaps(
      {
        let name = str(author.firstname + " " + author.lastname)
        name + " · " + curriculum-vitae
      },
      use-smallcaps,
    )
  ][
    #context {
      counter(page).display()
    }
  ]
}

#let default-closing(lang_data) = {
  align(bottom)[
    #text(weight: "light", style: "italic")[
      #linguify("attached", from: lang_data)#sym.colon #linguify(
        "curriculum-vitae",
        from: lang_data,
      )]
  ]
}
