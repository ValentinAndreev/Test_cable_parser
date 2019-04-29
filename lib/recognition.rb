# frozen_string_literal: true

require 'bundler/setup'
require 'yaml/store'

Bundler.require

module Recognition
  class Parser
    def parse_file(file = 'test.csv', path_to_data = 'data/cable.yml')
      result = []
      File.foreach(file) do |row|
        line = {}
        line['mark'] = parse_mark(row, store(path_to_data)['mark'].split(' '))
        line['voltage'] = parse_voltage(row) if line['mark']
        result << [line]
      end
      result
    end

    private

    def parse_mark(row, marks)
      marks.each do |mark|
        return mark if row =~ /#{mark}/i
      end
      nil
    end

    def parse_voltage(row)
      voltage = row.scan(/(\d*[,.]?\d*\s*(мкВ|мВ|В|кВ|МВ(;|.| )))/).flatten.reject { |v| v.to_f == 0 }.join
      voltage == '' ? nil : voltage
    end

    def store(path_to_data)
      @store ||= YAML.load_file(path_to_data)
    end
  end
end
