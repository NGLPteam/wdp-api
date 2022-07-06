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
            link_identifiers_globally: true,
          },
          {
            identifier: "ucm",
            title: "UC Merced",
            url: "https://dspace-pilot.escholarship.org/server/oai/request",
            set_identifier: "com_123456789_8",
            metadata_format: "mets",
            link_identifiers_globally: true,
          },
        ],
      },
      escholarship_v2: {
        communities: [
          {
            identifier: "uci",
            title: "UC Irvine",
            journals: [
              {
                identifier: "class_lta",
                title: "Journal for Learning through the Arts",
                url: "https://escholarship.org/oai",
                metadata_format: "oaidc",
                add_set: true,
                set_identifier: "class_lta",
              },
            ],
          },
          {
            identifier: "ucm",
            title: "UC Merced",
            journals: [
              {
                identifier: "ssha_transmodernity",
                title: "Transmodernity",
                subtitle: "Journal of Peripheral Cultural Production of the Luso-Hispanic World",
                url: "https://escholarship.org/oai",
                metadata_format: "oaidc",
                add_set: true,
                set_identifier: "ssha_transmodernity",
              },
            ],
          },
        ]
      },
      longleaf: {
        communities: [
          {
            identifier: "ecu",
            title: "East Carolina University",
            journals: [
              {
                identifier: "ncl",
                title: "North Carolina Libraries",
                url: "http://www.ncl.ecu.edu/index.php/NCL/oai",
                metadata_format: "oaidc",
              },
            ],
          },
          {
            identifier: "nccu",
            title: "North Carolina Central University",
            journals: [
              {
                identifier: "tpre",
                title: "Theory & Practice in Rural Education",
                url: "https://tpre.ecu.edu/index.php/tpre/oai",
                metadata_format: "oaidc",
                skip_harvest: true,
              },
            ]
          },
          {
            identifier: "ncsu",
            title: "North Carolina State University",
            journals: [
              {
                identifier: "acontracorriente",
                title: "A Contracorriente: una revista de estudios latinoamericanos",
                url: "https://acontracorriente.chass.ncsu.edu/index.php/acontracorriente/oai",
                metadata_format: "oaidc",
              }
            ]
          },
          {
            identifier: "unc-charlotte",
            title: "UNC Charlotte",
            journals: [
              {
                identifier: "dsj",
                title: "Dialogues in Social Justice: An Adult Education Journal",
                url: "https://journals.charlotte.edu/dsj/oai",
                metadata_format: "oaidc",
              },
              {
                identifier: "jaepr",
                title: "Journal of Applied Educational and Policy Research",
                url: "https://journals.charlotte.edu/jaepr/oai",
                metadata_format: "oaidc",
              },
              {
                identifier: "dialog",
                title: "HS Dialog: The Research to Practice Journal for the Early Childhood Field",
                url: "https://journals.charlotte.edu/dialog/oai",
                metadata_format: "oaidc",
              },
            ],
          },
          {
            identifier: "unc-greensboro",
            title: "UNC Greensboro",
            journals: [
              {
                identifier: "ccj",
                title: "Communication Center Journal",
                url: "https://libjournal.uncg.edu/ccj/oai",
                metadata_format: "oaidc",
              },
              {
                identifier: "fsm",
                title: "Found Sounds: UNCG Musicology Journal",
                url: "https://libjournal.uncg.edu/fsm/oai",
                metadata_format: "oaidc",
              },
              {
                identifier: "ijcp",
                title: "The International Journal of Critical Pedagogy",
                url: "https://libjournal.uncg.edu/ijcp/oai",
                metadata_format: "oaidc",
              },
              {
                identifier: "wpe",
                title: "Working Papers in Education",
                url: "https://libjournal.uncg.edu/wpe/oai",
                metadata_format: "oaidc",
              },
            ],
          },
          {
            identifier: "unc-wilmington",
            title: "UNC Wilmington",
            journals: [
              {
                identifier: "jethe",
                title: "Journal of Effective Teaching in Higher Education",
                url: "https://jethe.org/index.php/jethe/oai",
                metadata_format: "oaidc",
              },
            ],
          },
          {
            identifier: "education-research",
            title: "Education Research",
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
