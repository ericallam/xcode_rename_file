module XcodeRenameFile
  class Renamer
    def initialize project, group_scope, existing_name, new_name
      @project = project
      @existing_name = existing_name
      @new_name = new_name
      @group = project[group_scope]

      validate_renaming_settings
    end

    def rename!
      # Move the file
      existing_file_reference.real_path.rename existing_file_reference.real_path.to_s.gsub(@existing_name, @new_name)
      # Rename the file in the Xcode project
      existing_file_reference.path = existing_file_reference.path.gsub(@existing_name, @new_name)

      if header?
        other_files.each do |file|
          %x{ perl -pi -e 's/#{@existing_name}/#{@new_name}/g' #{file.real_path.to_s.gsub(" ", "\\ ")} }
        end
      end

      @project.save
    end

    private

    def other_files
      @other_files ||= @group.recursive_children.select {|child| child.isa == "PBXFileReference" }.reject {|file| file == existing_file_reference }
    end

    def existing_file_reference
      @existing_file_reference ||= find_scoped_file_by_name @existing_name
    end

    def header?
      File.extname(@new_name) == ".h"
    end

    def find_scoped_file_by_name name
      @group.recursive_children.detect {|f| f.display_name == name }
    end

    def validate_renaming_settings
      if new_file_reference = find_scoped_file_by_name(@new_name)
        abort_with_message "#{@new_name} is already in the group: #{new_file_reference.hierarchy_path}"
      end

      if File.extname(@existing_name) != File.extname(@new_name)
        abort_with_message "Cannot change the extension of the file while renaming"
      end

      unless existing_file_reference
        abort_with_message "Existing file not found in the project under the #{@group.display_name} group"
      end
    end

    def abort_with_message message
      raise ArgumentError.new("Attempt to rename #{@existing_name} to #{@new_name} failed: #{message}")
    end
  end
end