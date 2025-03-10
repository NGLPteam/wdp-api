# frozen_string_literal: true

class AddMappingTemplates < ActiveRecord::Migration[7.0]
  DEFAULT_JATS_MAPPING = <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <mapping>
    <assigns>
      <assign name="lang">{{jats.lang}}</assign>
    </assigns>
    <contributions vocabulary="marc_codes">
      <map-external-role from="author" case-insensitive="true" to="aut" />
    </contributions>
    <entities>
      <collection schema="nglp:journal_volume">
        <requires>
          <expr reason="must have a volume">{{jats.volume}}</expr>
        </requires>
        <identifier>volume-{{jats.volume}}</identifier>
        <title>Volume {{jats.volume}}</title>
        <properties>
          <string path="id">{{jats.volume}}</string>
          <integer path="sortable_number">{{jats.volume}}</integer>
        </properties>
        <collection schema="nglp:journal_issue">
          <requires>
            <expr reason="must have an issue">{{jats.issue}}</expr>
          </requires>
          <identifier>issue-{{jats.issue}}</identifier>
          <title>Issue {{jats.issue}}</title>
          <properties>
            <string path="id">{{jats.issue}}</string>
            <integer path="sortable_number">{{jats.issue}}</integer>
          </properties>
          <item schema="nglp:journal_article">
            <identifier>{{record.identifier}}</identifier>
            <title>{{jats.article_title}}</title>
            <doi>
              {% assign doi = jats.front.article_meta.article_id | where: "pub_id_type", "doi" | first %}

              {{doi}}
            </doi>
            <properties>
              <full-text path="body" lang="{{lang}}">
                {{jats.body}}
              </full-text>
              <full-text path="abstract" lang="{{lang}}">
                {{jats.abstract}}
              </full-text>
              <tags path="keywords">
                {% for group in jats.front.article_meta.kwd_group %}
                {% for kwd in group.kwd %}
                {% tag %}{{kwd}}{% endtag %}
                {% endfor %}
                {% endfor %}
              </tags>
              <asset path="pdf_version">
                <kind>pdf</kind>
                <mime-type>application/pdf</mime-type>
                <name>PDF Version</name>
                <url>
                  {% assign pdf = jats.front.article_meta.self_uri | where: "content_type", "application/pdf" | first %}

                  {% if pdf %}
                  {{pdf.href}}
                  {% endif %}
                </url>
              </asset>
              <url path="online_version">
                <href>
                  {% assign url = jats.front.article_meta.self_uri | where: "content_type", "text/html" | first %}

                  {% if url %}
                  {{url.href}}
                  {% endif %}
                </href>
                <label>{{jats.article_title}} — Janeway</label>
              </url>
            </properties>
          </item>
        </collection>
      </collection>
    </entities>
  </mapping>
  XML

  def change
    change_table :harvest_sources do |t|
      t.text :extraction_mapping_template, null: false, default: ""
    end

    change_table :harvest_mappings do |t|
      t.text :extraction_mapping_template, null: false, default: ""
    end

    change_table :harvest_attempts do |t|
      t.text :extraction_mapping_template, null: false, default: ""
    end
  end
end
