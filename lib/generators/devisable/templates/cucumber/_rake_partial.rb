task :setup_js_with_xvfb do
  puts "Cucumber test with Xvfb and firefox"
  ENV['DISPLAY'] = ":99"
  %x{Xvfb :99 -ac -screen 0 1024x768x16 2>/dev/null >/dev/null &}
  %x{firefox --display=:99 2>/dev/null >/dev/null &}
end 

task :setup_js_with_vnc4server do
  puts "Cucumber test with vnc4server"
  ENV['DISPLAY'] = ":99"
  %x{vncserver :99 2>/dev/null >/dev/null &}
  %x{DISPLAY=:99 firefox 2>/dev/null >/dev/null &}
end 

task :kill_js do
  puts "Killing vnc, xvfb, and ff processes"
  %x{killall Xvnc4}
  %x{killall Xvfb}
  %x{killall firefox}
end 


