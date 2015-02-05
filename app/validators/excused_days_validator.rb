class ExcusedDaysValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, valueArray)
    valueArray.each do |value|
      record.errors.add attribute, "may not be blank" unless valueArray.count > 1
    end
  end 
end