module ExcusedUsersHelper
  def dayspt
    @days = Group.all
    @daystring = Array.new
    @days.each do |d|
      @total = (d.ptdays).split("::")
      @total.each do |t|
        @daystring << t
      end
    end
    @daystring = @daystring.uniq
    return @daystring
  end
  
  def daysllab
    @days = Group.all
    @daystring = Array.new
    @days.each do |d|
      @total = (d.llabdays).split("::")
      @total.each do |t|
        @daystring << t
      end
    end
    @daystring = @daystring.uniq
    return @daystring
  end

end
