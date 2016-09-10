Role.create!([
  {name: "Player"},
  {name: "Admin"},
  {name: "Guest"}
])

business = Business.create! :name => 'EngagePerPage', :email => 'engageperpage@gmail.com', :password => 'dybgwdtr1;;', :password_confirmation => 'dybgwdtr1;;', :role => "Admin"
business.save

demo = Business.create! :name => 'Demo', :email => 'demo.engageperpage@gmail.com', :password => 'demouser', :password_confirmation => 'demouser', :role => "Guest"
demo.save 