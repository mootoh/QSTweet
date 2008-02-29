#
# shared.rb - shared Logger Factory
#
# TwitterPlugin
#   License: revised BSD
#   Motohiro Takayama <mootoh@gmail.com>
#
class Shared
  PUBLIC = 'QSTwitter'
  def Shared.set_logger(logger)
    @@logger = logger
  end

  def Shared.logger
    @@logger
  end
end
