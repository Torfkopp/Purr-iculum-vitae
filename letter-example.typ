#import "utils/letter-template.typ": *

#show: coverletter.with(
  // Or set the value to `true`
  show-footer: false,
  // this defaults to false
  show-address-icon: true,
  // set this to `none` to show the default or remove it completely
  closing: [],
  // see typst "page" documentation for more options
  description: "Cover letter of John",
  keywords: ("Software"),
)

// #hiring-entity-info(
//   entity-info: (
//     target: "Company Recruitement Team",
//     name: "Google, Inc.",
//     street-address: "1600 AMPHITHEATRE PARKWAY",
//     city: "MOUNTAIN VIEW, CA 94043",
//   ),
// )

#letter-heading(job-position: "Software Engineer", addressee: "Sir or Madame")

= About Me
#coverletter-content[
  #lorem(80)
]

= Why Google?
#coverletter-content[
  #lorem(90)
]

= Why Me?
#coverletter-content[
  #lorem(100)
]