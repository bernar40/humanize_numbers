# coding: utf-8
module HumanizeNumbers
  module Numeric
    def self.included(recipient)
      recipient.extend(ClassMethods)
      recipient.class_eval do
        include InstanceMethods
      end
    end

    module ClassMethods
    end

    module InstanceMethods

      def humanize

        words = []
        quantities_array_es = %w[ ~ ~ milli ~ billi ~ trilli ~ ]
        number = self.to_f
        conector = "con"
        zero_string = "cero"

        if number.to_i == 0
          words << zero_string
        else
          decimal = number.to_s.split(".")[1].nil? ? 0 : number.to_s.split(".")[1]
          number = number.to_s.split(".")[0]

          number = number.rjust(33,'0').reverse
          groups = number.scan(/.../)

          words << number_to_words(groups[0].reverse)


          (1..10).each do |number|
            if groups[number].to_i > 0
              if number == 1 || number == 3 || number == 5 || number == 7 || number == 9
                  words << "mil"
                else
                  words << (groups[number].reverse.to_i > 1 ? "#{quantities_array_es[number]}ones" : "#{quantities_array_es[number]}ón")
                end
              words << number_to_words(groups[number].reverse)
            end
          end
        end
        return "#{words.reverse.join(' ')} #{conector} #{decimal}/100"
      end

      protected

      def number_to_words(number)

        hundreds = number[0,1].to_i
        tens = number[1,1].to_i
        units = number[2,1].to_i
        hundreds_array = %w[ cien ciento doscientos trescientos cuatrocientos quinientos seiscientos setecientos ochocientos novecientos ]
        units_array = %w[ ~ un dos tres cuatro cinco seis siete ocho nueve ]
        teens_array = %w[ diez once doce trece catorce quince dieciseis diecisiete dieciocho diecinueve ]
        tens_array = %w[ ~ diez veinte treinta cuarenta cincuenta sesenta setenta ochenta noventa ]
        and_string = "y"
        text = []

        if hundreds > 0
          if hundreds == 1 && (tens + units == 0)
            #text << self.hundreds[0]
            text << hundreds_array[0]
          else
            #text << self.hundreds[hundreds]
            text << hundreds_array[hundreds]
          end
        end

        if tens > 0
          case tens
          when 1
            text << (units == 0 ? tens_array[tens] : teens_array[units])
          when 2
            text << (units == 0 ? tens_array[tens] : "veinti#{units_array[units]}")
          else
            text << tens_array[tens]
          end
        end

        if units > 0
          if tens == 0
            text << units_array[units]
          elsif tens > 2
            text << "#{and_string} #{units_array[units]}"
          end
        end
        return text.join(' ')
      end

    end
  end
end

Numeric.send :include, HumanizeNumbers::Numeric
