cask 'adobe-photoshop-cc-it' do
  version :latest
  sha256 :no_check

  url 'http://trials3.adobe.com/AdobeProducts/PHSP/16/osx10/Photoshop_16_LS20.dmg',
      user_agent: :fake,
      cookies:    { 'MM_TRIALS' => '1234' }
  name 'Adobe Photoshop CC 2015'
  homepage 'https://www.adobe.com/products/photoshop.html'
  license :commercial

  conflicts_with cask: 'adobe-photoshop-cc'

  preflight do
    system '/usr/bin/sudo', '-E', '--', "#{staged_path}/Adobe Photoshop CC 2015/Install.app/Contents/MacOS/Install", '--mode=silent', "--deploymentFile=#{staged_path}/Adobe\ Photoshop\ CC\ 2015/Deployment/it_IT_Deployment.xml"
  end

  uninstall_preflight do
    uninstall_xml = "#{staged_path}/uninstall.xml"

    IO.write uninstall_xml, <<-EOF.undent
      <?xml version="1.0" encoding="utf-8"?>
      <Deployment>
        <Properties>
          <Property name="removeUserPrefs">0</Property>
          <Property name="mediaSignature">{2614BC86-757D-4293-9E25-E4E16F370A9E}</Property>
        </Properties>
        <Payloads>
          <Payload adobeCode="{2614BC86-757D-4293-9E25-E4E16F370A9E}">
            <Action>remove</Action>
          </Payload>
        </Payloads>
      </Deployment>
    EOF

    system '/usr/bin/sudo', '-E', '--', "#{staged_path}/Adobe Photoshop CC 2015/Install.app/Contents/MacOS/Install", '--mode=silent', "--deploymentFile=#{uninstall_xml}"
  end

  uninstall rmdir: '/Applications/Utilities/Adobe Installers'
end
