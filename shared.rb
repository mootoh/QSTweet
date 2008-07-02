#
# shared.rb - shared Logger Factory
#
# WassrPlugin
#   License: revised BSD
#   Motohiro Takayama <mootoh@gmail.com>
#
class Shared
  PUBLIC = 'QSWassr'
  def Shared.set_logger(logger)
    @@logger = logger
  end

  def Shared.logger
    @@logger
  end
end
