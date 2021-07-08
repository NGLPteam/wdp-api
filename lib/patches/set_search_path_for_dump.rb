# frozen_string_literal: true

require "active_record/tasks/postgresql_database_tasks"

module Patches
  module SetSearchPathForDump
    DELETE = Object.new.freeze

    def structure_dump(filename, extra_flags)
      super

      edit_file filename do |line|
        next unless line =~ /pg_catalog\.set_config\('search_path'/

        line.gsub(/''/, %['"$user",public'])
      end
    end

    def edit_file(filename)
      Tempfile.open(".#{File.basename(filename)}", File.dirname(filename)) do |tempfile|
        File.open(filename).each do |line|
          new_line = yield line

          next if new_line == DELETE

          if new_line.blank?
            tempfile.puts line
          else
            tempfile.puts new_line
          end
        end

        tempfile.fdatasync
        tempfile.close

        FileUtils.mv tempfile.path, filename
      end
    end
  end
end

ActiveRecord::Tasks::PostgreSQLDatabaseTasks.prepend Patches::SetSearchPathForDump
