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
            ],
            series: [
              {
                identifier: "mt",
                title: "Masters' Theses",
                url: "https://repository.arizona.edu/oai/request",
                set_identifier: "col_10150_129651",
                max_records: 100,
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
            journals: [
              {
                identifier: "codee",
                title: "CODEE",
                url: "https://claremont.nglp.olh.pub/codee/api/oai",
              },
              {
                identifier: "envirolabasia",
                title: "Envirolab Asia",
                url: "https://claremont.nglp.olh.pub/envirolabasia/api/oai",
              },
            ],
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
              },
            ],
          },
        ],
      },
      escholarship: {
        communities: [
          {
            identifier: "uci",
            title: "UC Irvine",
            url: "https://dspace-pilot.escholarship.org/server/oai/request",
            set_identifier: "com_123456789_5906",
            metadata_format: "mets",
          },
          {
            identifier: "ucm",
            title: "UC Merced",
            url: "https://dspace-pilot.escholarship.org/server/oai/request",
            set_identifier: "com_123456789_8",
            metadata_format: "mets",
          },
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
                identifier: "ellipsis",
                title: "Ellipsis",
                url: "https://neworleans.nglp.olh.pub/ellipsis/api/oai/",
              },
              {
                identifier: "beyondthemargins",
                title: "Beyond The Margins",
                url: "https://neworleans.nglp.olh.pub/beyondthemargins/api/oai/",
              },
            ],
          },
        ],
      },
    }.freeze

    def call(key)
      definition = DEFINITIONS.fetch key.to_sym

      root = PilotHarvesting::Root.new(definition)

      root.call
    end
  end
end
