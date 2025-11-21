export default function ImpressumPage() {
  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section className="relative flex min-h-[40vh] items-center justify-center overflow-hidden bg-gradient-to-br from-schnittwerk-50 via-white to-gold-50">
        <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-5" />

        <div className="container-custom relative z-10 text-center">
          <h1 className="mb-6 text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl">
            Impressum
          </h1>
        </div>
      </section>

      {/* Legal Content */}
      <section className="container-custom py-20">
        <div className="mx-auto max-w-3xl space-y-8">
          {/* Company Information */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Angaben gemäss OR</h2>
            <div className="space-y-2 text-schnittwerk-700">
              <p className="font-semibold">SCHNITTWERK by Vanessa Carosella</p>
              <p>Rorschacherstrasse 152</p>
              <p>9000 St. Gallen</p>
              <p>Schweiz</p>
            </div>
          </div>

          {/* Contact */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Kontakt</h2>
            <div className="space-y-2 text-schnittwerk-700">
              <p>
                <span className="font-medium">Telefon:</span>{" "}
                <a href="tel:+41712345678" className="hover:text-gold-600">
                  +41 71 234 56 78
                </a>
              </p>
              <p>
                <span className="font-medium">E-Mail:</span>{" "}
                <a
                  href="mailto:info@schnittwerk.ch"
                  className="hover:text-gold-600"
                >
                  info@schnittwerk.ch
                </a>
              </p>
            </div>
          </div>

          {/* Business Registration */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">
              Handelsregister
            </h2>
            <div className="space-y-2 text-schnittwerk-700">
              <p>
                <span className="font-medium">Handelsregistereintrag:</span>{" "}
                Eingetragen im Handelsregister des Kantons St. Gallen
              </p>
              <p>
                <span className="font-medium">UID:</span> CHE-XXX.XXX.XXX
              </p>
              <p>
                <span className="font-medium">
                  Mehrwertsteuernummer (MWST):
                </span>{" "}
                CHE-XXX.XXX.XXX MWST
              </p>
            </div>
          </div>

          {/* Responsible Person */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">
              Vertretungsberechtigte Person
            </h2>
            <p className="text-schnittwerk-700">Vanessa Carosella, Inhaberin</p>
          </div>

          {/* Disclaimer */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Haftungsausschluss</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">Inhalt des Onlineangebotes</h3>
                <p>
                  Der Autor übernimmt keinerlei Gewähr hinsichtlich der
                  inhaltlichen Richtigkeit, Genauigkeit, Aktualität,
                  Zuverlässigkeit und Vollständigkeit der Informationen.
                  Haftungsansprüche gegen den Autor wegen Schäden materieller
                  oder immaterieller Art, welche aus dem Zugriff oder der
                  Nutzung bzw. Nichtnutzung der veröffentlichten Informationen,
                  durch Missbrauch der Verbindung oder durch technische Störungen
                  entstanden sind, werden ausgeschlossen.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">Verweise und Links</h3>
                <p>
                  Verweise und Links auf Webseiten Dritter liegen ausserhalb
                  unseres Verantwortungsbereichs. Es wird jegliche
                  Verantwortung für solche Webseiten abgelehnt. Der Zugriff und
                  die Nutzung solcher Webseiten erfolgen auf eigene Gefahr des
                  Nutzers oder der Nutzerin.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">Urheberrechte</h3>
                <p>
                  Die Urheber- und alle anderen Rechte an Inhalten, Bildern,
                  Fotos oder anderen Dateien auf der Website gehören
                  ausschliesslich SCHNITTWERK by Vanessa Carosella oder den
                  speziell genannten Rechtsinhabern. Für die Reproduktion
                  jeglicher Elemente ist die schriftliche Zustimmung der
                  Urheberrechtsträger im Voraus einzuholen.
                </p>
              </div>
            </div>
          </div>

          {/* Data Protection */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">Datenschutz</h2>
            <p className="text-schnittwerk-700">
              Gestützt auf Artikel 13 der schweizerischen Bundesverfassung und
              die datenschutzrechtlichen Bestimmungen des Bundes
              (Datenschutzgesetz, DSG) hat jede Person Anspruch auf Schutz ihrer
              Privatsphäre sowie auf Schutz vor Missbrauch ihrer persönlichen
              Daten. Weitere Informationen finden Sie in unserer{" "}
              <a
                href="/datenschutz"
                className="font-medium text-gold-600 hover:text-gold-700"
              >
                Datenschutzerklärung
              </a>
              .
            </p>
          </div>

          {/* Technical Implementation */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">
              Technische Umsetzung
            </h2>
            <p className="text-schnittwerk-700">
              Diese Website wurde mit modernen Webtechnologien entwickelt und
              entspricht den aktuellen Standards für Sicherheit und
              Datenschutz.
            </p>
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
