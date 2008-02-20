#
# qs_action.rb - actual Action behavior
#
# TwitterPlugin
#   License: revised BSD
#   Motohiro Takayama <mootoh@gmail.com>
#
require 'osx/cocoa'
require 'shared'
require 'cgi'
require 'kconv'

# 
# does actual Action
#
class TwitterPluginAction < OSX::QSActionProvider
  # reload itself
  def reload
    Shared.logger.info('reloading ' + __FILE__)
    load(__FILE__)
  end

  # get screenName:password from PreferencePane
  def name_pass
    dict = OSX::NSUserDefaultsController.sharedUserDefaultsController.values;
    screen_name = dict.valueForKey("TwitterPreference.screenName")
    password    = dict.valueForKey("TwitterPreference.password")
    screen_name.to_s + ':' + password
  end

  def make_request(content)
    u = 'http://' + name_pass + '@twitter.com/statuses/update.json'
    # Shared.logger.info(u.to_s)

    req = OSX::NSMutableURLRequest.alloc.initWithURL(OSX::NSURL.URLWithString(u))
    req.setHTTPMethod('POST')
    content = Kconv.toutf8(content)
    req.setHTTPBody(OSX::NSData.dataWithBytes_length(content, content.size))
    req
  end
    
  def post(arg)
    str = arg.stringValue.to_s
    if str == '/reload'
      reload
      return arg
    end

    begin
      content = 'source=QSTwitter&status=' + CGI.escape(str)
      req = make_request(content)
      con = OSX::NSURLConnection.connectionWithRequest_delegate(req, self)
      # Shared.logger.info(con ? "request succeeded" : "request failed")
    rescue
    end

    arg
  end

  #
  # callbacks
  #
  def connection_didReceiveResponse(con, res)
    #Shared.logger.info("connection_didReceiveResponse")
  end

  def connection_didReceiveData(con, data)
    #Shared.logger.info("connection_didReceiveData")
    #OSX::QSShowNotifierWithAttributes({'QSTwitter' => OSX::QSNotifierTitle, 'posted' => OSX::QSNotifierText})
  end

  def connection_didFailWithErro(con, err)
    #Shared.logger.info("connection_didFailWithErro")
  end

  def connectiondidFinishLoading(con)
    #Shared.logger.info("connectiondidFinishLoading")
  end
end # Action
