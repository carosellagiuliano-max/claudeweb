export default function DataProtectionPage() {
  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section className="relative flex min-h-[40vh] items-center justify-center overflow-hidden bg-gradient-to-br from-schnittwerk-50 via-white to-gold-50">
        <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-5" />

        <div className="container-custom relative z-10 text-center">
          <h1 className="mb-6 text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl">
            Datenschutzerklärung
          </h1>
        </div>
      </section>

      {/* Privacy Content */}
      <section className="container-custom py-20">
        <div className="mx-auto max-w-3xl space-y-8">
          {/* Introduction */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Einleitung</h2>
            <p className="text-schnittwerk-700">
              SCHNITTWERK by Vanessa Carosella nimmt den Schutz Ihrer
              persönlichen Daten sehr ernst. Wir behandeln Ihre personenbezogenen
              Daten vertraulich und entsprechend der gesetzlichen
              Datenschutzvorschriften sowie dieser Datenschutzerklärung. Diese
              Datenschutzerklärung klärt Sie über die Art, den Umfang und Zweck
              der Verarbeitung von personenbezogenen Daten innerhalb unseres
              Onlineangebotes und der damit verbundenen Webseiten, Funktionen und
              Inhalte auf.
            </p>
          </div>

          {/* Responsible Party */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Verantwortliche Stelle</h2>
            <div className="space-y-2 text-schnittwerk-700">
              <p className="font-semibold">SCHNITTWERK by Vanessa Carosella</p>
              <p>Rorschacherstrasse 152</p>
              <p>9000 St. Gallen</p>
              <p>Schweiz</p>
              <p className="mt-4">
                <span className="font-medium">E-Mail:</span>{" "}
                <a
                  href="mailto:datenschutz@schnittwerk.ch"
                  className="hover:text-gold-600"
                >
                  datenschutz@schnittwerk.ch
                </a>
              </p>
            </div>
          </div>

          {/* Legal Basis */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Rechtsgrundlagen</h2>
            <p className="text-schnittwerk-700">
              Die Verarbeitung personenbezogener Daten erfolgt auf Grundlage des
              schweizerischen Datenschutzgesetzes (DSG) und der
              EU-Datenschutz-Grundverordnung (DSGVO), soweit diese anwendbar ist.
            </p>
          </div>

          {/* Data Collection */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">
              Erhebung und Verarbeitung personenbezogener Daten
            </h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">1. Webseitenbesuch</h3>
                <p>
                  Beim Besuch unserer Website werden automatisch Informationen
                  allgemeiner Natur erfasst. Diese Informationen (Server-Logfiles)
                  beinhalten etwa die Art des Webbrowsers, das verwendete
                  Betriebssystem, den Domainnamen Ihres Internet-Service-Providers
                  und Ähnliches. Hierbei handelt es sich ausschliesslich um
                  Informationen, welche keine Rückschlüsse auf Ihre Person
                  zulassen.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">2. Kontaktformular</h3>
                <p>
                  Wenn Sie uns per Kontaktformular Anfragen zukommen lassen,
                  werden Ihre Angaben aus dem Anfrageformular inklusive der von
                  Ihnen dort angegebenen Kontaktdaten zwecks Bearbeitung der
                  Anfrage und für den Fall von Anschlussfragen bei uns
                  gespeichert.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">3. Online-Terminbuchung</h3>
                <p>
                  Für die Terminbuchung erheben wir folgende Daten: Name,
                  E-Mail-Adresse, Telefonnummer sowie gewünschte
                  Dienstleistungen. Diese Daten werden ausschliesslich zur
                  Durchführung und Verwaltung Ihrer Termine verwendet.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">4. Kundenkonto</h3>
                <p>
                  Wenn Sie ein Kundenkonto erstellen, speichern wir Ihre
                  Anmeldedaten (E-Mail, verschlüsseltes Passwort) sowie Ihre
                  Profilinformationen. Sie haben jederzeit das Recht, Ihr Konto
                  zu löschen.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">5. Online-Shop</h3>
                <p>
                  Bei Bestellungen in unserem Online-Shop erheben wir Name,
                  Liefer- und Rechnungsadresse, E-Mail-Adresse sowie
                  Zahlungsinformationen. Die Zahlungsabwicklung erfolgt über
                  unseren Zahlungsdienstleister Stripe.
                </p>
              </div>
            </div>
          </div>

          {/* Purpose of Data Processing */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Zweck der Datenverarbeitung</h2>
            <ul className="list-inside list-disc space-y-2 text-schnittwerk-700">
              <li>Bereitstellung und Betrieb der Website</li>
              <li>Bearbeitung von Kontaktanfragen</li>
              <li>Terminverwaltung und -erinnerungen</li>
              <li>Abwicklung von Bestellungen</li>
              <li>Kundenservice und -betreuung</li>
              <li>Verbesserung unserer Dienstleistungen</li>
              <li>Erfüllung gesetzlicher Aufbewahrungspflichten</li>
            </ul>
          </div>

          {/* Data Storage */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Datenspeicherung und -sicherheit</h2>
            <p className="text-schnittwerk-700">
              Ihre Daten werden auf sicheren Servern innerhalb der EU/Schweiz
              gespeichert. Wir verwenden technische und organisatorische
              Sicherheitsmassnahmen, um Ihre Daten gegen zufällige oder
              vorsätzliche Manipulationen, Verlust, Zerstörung oder gegen den
              Zugriff unberechtigter Personen zu schützen. Unsere
              Sicherheitsmassnahmen werden entsprechend der technologischen
              Entwicklung fortlaufend verbessert.
            </p>
          </div>

          {/* Data Retention */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Aufbewahrungsdauer</h2>
            <p className="text-schnittwerk-700">
              Wir speichern personenbezogene Daten nur so lange, wie es für die
              Erfüllung des jeweiligen Zwecks erforderlich ist oder wie es
              gesetzliche Aufbewahrungsfristen vorsehen. Geschäftsbücher und
              Belege werden gemäss schweizerischem Obligationenrecht für
              mindestens 10 Jahre aufbewahrt.
            </p>
          </div>

          {/* Third Party Services */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Dienste von Drittanbietern</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">Supabase (Datenbank & Auth)</h3>
                <p>
                  Wir nutzen Supabase für die Datenspeicherung und
                  Benutzerauthentifizierung. Die Server befinden sich in der EU.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">Stripe (Zahlungsabwicklung)</h3>
                <p>
                  Zahlungen werden über Stripe abgewickelt. Stripe ist PCI-DSS
                  Level 1 zertifiziert. Weitere Informationen finden Sie in der
                  Datenschutzerklärung von Stripe.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">Resend (E-Mail-Versand)</h3>
                <p>
                  Für den Versand von Transaktions-E-Mails (Terminbestätigungen,
                  Bestellbestätigungen) nutzen wir Resend.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">Sentry (Fehlerüberwachung)</h3>
                <p>
                  Zur Verbesserung der Systemstabilität nutzen wir Sentry für die
                  Fehlererfassung. Dabei werden keine personenbezogenen Daten
                  übermittelt.
                </p>
              </div>
            </div>
          </div>

          {/* User Rights */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Ihre Rechte</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <p>Sie haben folgende Rechte:</p>
              <ul className="list-inside list-disc space-y-2">
                <li>
                  <span className="font-medium">Auskunftsrecht:</span> Sie haben
                  das Recht, Auskunft über Ihre bei uns gespeicherten Daten zu
                  erhalten.
                </li>
                <li>
                  <span className="font-medium">Berichtigungsrecht:</span> Sie
                  haben das Recht, unrichtige Daten berichtigen zu lassen.
                </li>
                <li>
                  <span className="font-medium">Löschungsrecht:</span> Sie haben
                  das Recht, die Löschung Ihrer Daten zu verlangen.
                </li>
                <li>
                  <span className="font-medium">
                    Einschränkung der Verarbeitung:
                  </span>{" "}
                  Sie haben das Recht, die Einschränkung der Verarbeitung Ihrer
                  Daten zu verlangen.
                </li>
                <li>
                  <span className="font-medium">Datenübertragbarkeit:</span> Sie
                  haben das Recht, Ihre Daten in einem strukturierten, gängigen
                  Format zu erhalten.
                </li>
                <li>
                  <span className="font-medium">Widerspruchsrecht:</span> Sie
                  haben das Recht, der Verarbeitung Ihrer Daten zu widersprechen.
                </li>
              </ul>
              <p className="mt-4">
                Zur Ausübung Ihrer Rechte kontaktieren Sie uns bitte unter{" "}
                <a
                  href="mailto:datenschutz@schnittwerk.ch"
                  className="font-medium text-gold-600 hover:text-gold-700"
                >
                  datenschutz@schnittwerk.ch
                </a>
              </p>
            </div>
          </div>

          {/* Cookies */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Cookies</h2>
            <p className="text-schnittwerk-700">
              Unsere Website verwendet Cookies. Dabei handelt es sich um kleine
              Textdateien, die auf Ihrem Endgerät gespeichert werden. Wir
              verwenden ausschliesslich technisch notwendige Cookies für die
              Funktionalität der Website (Session-Cookies für Login, Warenkorb).
              Diese werden nach Ende Ihrer Browser-Sitzung automatisch gelöscht.
            </p>
          </div>

          {/* SSL/TLS */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">SSL/TLS-Verschlüsselung</h2>
            <p className="text-schnittwerk-700">
              Diese Website nutzt aus Sicherheitsgründen und zum Schutz der
              Übertragung vertraulicher Inhalte eine SSL/TLS-Verschlüsselung. Eine
              verschlüsselte Verbindung erkennen Sie daran, dass die Adresszeile
              des Browsers von "http://" auf "https://" wechselt und an dem
              Schloss-Symbol in Ihrer Browserzeile.
            </p>
          </div>

          {/* Changes */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">
              Änderungen der Datenschutzerklärung
            </h2>
            <p className="text-schnittwerk-700">
              Wir behalten uns vor, diese Datenschutzerklärung gelegentlich
              anzupassen, damit sie stets den aktuellen rechtlichen Anforderungen
              entspricht oder um Änderungen unserer Leistungen umzusetzen. Für
              Ihren erneuten Besuch gilt dann die neue Datenschutzerklärung.
            </p>
          </div>

          {/* Supervisory Authority */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Aufsichtsbehörde</h2>
            <div className="text-schnittwerk-700">
              <p className="mb-2">
                Bei Fragen zum Datenschutz können Sie sich an folgende
                Aufsichtsbehörde wenden:
              </p>
              <p className="font-medium">
                Eidgenössischer Datenschutz- und Öffentlichkeitsbeauftragter
                (EDÖB)
              </p>
              <p>Feldeggweg 1</p>
              <p>3003 Bern</p>
              <p>Schweiz</p>
              <p className="mt-2">
                <a
                  href="https://www.edoeb.admin.ch"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-gold-600"
                >
                  www.edoeb.admin.ch
                </a>
              </p>
            </div>
          </div>

          <div className="border-t border-schnittwerk-200 pt-6">
            <p className="text-sm text-schnittwerk-500">
              Stand: November 2025
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}
