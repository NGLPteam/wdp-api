# frozen_string_literal: true

require "shale/adapter/nokogiri"
require "shale/adapter/ox"
require "shale/schema"

Shale.toml_adapter = Tomlib

Shale.xml_adapter = Shale::Adapter::Ox
