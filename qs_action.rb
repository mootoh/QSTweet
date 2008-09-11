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
require 'net/http'
require 'uri'

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

  def name_and_pass
    dict = OSX::NSUserDefaultsController.sharedUserDefaultsController.values;
    screen_name = dict.valueForKey("TwitterPreference.screenName")
    password    = dict.valueForKey("TwitterPreference.password")
    [screen_name.to_s, password]
  end

  def make_request_with_cocoa(content)
    u = 'http://' + name_pass + '@twitter.com/statuses/update.json'
    Shared.logger.info(u.to_s)

    req = OSX::NSMutableURLRequest.alloc.initWithURL(OSX::NSURL.URLWithString(u))
    req.setHTTPMethod('POST')
    content = Kconv.toutf8(content)
    req.setHTTPBody(OSX::NSData.dataWithBytes_length(content, content.size))
    req
  end

  def request_with_cocoa(req)
    con = OSX::NSURLConnection.connectionWithRequest_delegate(req, self)
    Shared.logger.info(con ? "request succeeded" : "request failed")
  end

  def make_request(content)
    req = Net::HTTP::Post.new('/statuses/update.json')
    np = name_and_pass
    req.basic_auth np[0], np[1]
    req.body = Kconv.toutf8(content)
    req
  end

  def request(req)
    http = if ENV['http_proxy']
      u = URI.parse(ENV['http_proxy'])
      Net::HTTP::Proxy(u.host, u.port).new('twitter.com')
    else
      Net::HTTP.new('twitter.com')
    end

    res = http.request(req)
    Shared.logger.info(res.message)
    res
  end
    
  def post_to(arg, friend)
    str = arg.stringValue.to_s
    if str == '/reload'
      Shared.logger.info('reload')
      reload
      return arg
    end

    if friend && (friend.stringValue.to_s != Shared::PUBLIC)
      str = '@' + friend.stringValue.to_s + ' ' + str
      Shared.logger.info(str)
    end

    begin
      content = 'source=QSTwitter&status=' + CGI.escape(str)
      Thread.new {
        request(make_request(content))
      }
    rescue
    end

    arg
  end

  def validIndirectObjectsForAction_directObject(action, dobj)
    Shared.logger.info('validIndirectObjectsForAction_directObject')
    #[NSArray arrayWithObject:[QSObject textProxyObjectWithDefault    Value:@""]];
    if dobj.primaryType.isEqualToString 'TwitterPluginType'
      [OSX::QSObject.textProxyObjectWithDefaultValue('')]
    end
  end

  #
  # callbacks for Cocoa HTTP request
  #
  def connection_didReceiveResponse(con, res)
    Shared.logger.info('connection_didReceiveResponse' + res.statusCode.to_s)
  end

  def connection_didReceiveData(con, data)
    Shared.logger.info('connection_didReceiveData' + data.to_s)
    #OSX::QSShowNotifierWithAttributes({'QSTwitter' => OSX::QSNotifierTitle, 'posted' => OSX::QSNotifierText})
  end

  def connection_didFailWithErro(con, err)
    Shared.logger.info('connection_didFailWithErro' + err.to_s)
  end

  def connectiondidFinishLoading(con)
    Shared.logger.info("connectiondidFinishLoading")
  end
end # Action
