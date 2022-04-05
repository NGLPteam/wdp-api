# frozen_string_literal: true

module PilotHarvesting
  class Seed
    DEFINITIONS = {
      arizona: {
        communities: [
          {
            identifier: "arizona",
            title: "University of Arizona",
            journals: [
              {
                identifier: "jpe",
                title: "Journal of Political Ecology",
                url: "https://journals.librarypublishing.arizona.edu/jpe/api/oai/",
              },
              {
                identifier: "lymph",
                title: "Lymphology",
                url: "https://journals.librarypublishing.arizona.edu/lymph/api/oai/",
              }
            ]
          }
        ],
      },
      claremont: {
        communities: [
          {
            identifier: "claremont",
            title: "Claremont",
          },
        ],
      },
      clemson: {
        communities: [
          {
            identifier: "clemson",
            title: "Clemson",
            journals: [
              {
                identifier: "joe",
                title: "Journal of Extension",
                url: "https://demo.janeway.systems/joe/api/oai/",
              }
            ]
          }
        ],
      },
      umassamherst: {
        communities: [
          {
            identifier: "umassamherst",
            title: "University of Massachusetts: Amherst",
            journals: [
              {
                identifier: "pare",
                title: "Practical Assessment, Research, and Evaluation",
                url: "https://demo.janeway.systems/pare/api/oai/",
              },
              {
                identifier: "translatlib",
                title: "Translat Library",
                url: "https://demo.janeway.systems/translatlib/api/oai/",
              },
            ]
          }
        ],
      },
      uno: {
        communities: [
          {
            identifier: "uno",
            title: "University of New Orleans",
            journals: [
              {
                identifier: "neworleans",
                title: "New Orleans",
                url: "https://demo.janeway.systems/neworleans/api/oai/",
              },
            ],
          },
        ],
      },
    }.freeze

    def call(key)
      definition = DEFINITIONS.fetch key

      root = PilotHarvesting::Root.new(definition)

      root.call
    end
  end
end
