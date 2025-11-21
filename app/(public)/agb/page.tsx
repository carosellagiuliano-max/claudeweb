export default function TermsPage() {
  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section className="relative flex min-h-[40vh] items-center justify-center overflow-hidden bg-gradient-to-br from-schnittwerk-50 via-white to-gold-50">
        <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-5" />

        <div className="container-custom relative z-10 text-center">
          <h1 className="mb-6 text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl">
            Allgemeine Geschäftsbedingungen
          </h1>
        </div>
      </section>

      {/* Terms Content */}
      <section className="container-custom py-20">
        <div className="mx-auto max-w-3xl space-y-8">
          {/* Introduction */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">1. Geltungsbereich</h2>
            <p className="text-schnittwerk-700">
              Diese Allgemeinen Geschäftsbedingungen (AGB) gelten für alle
              Dienstleistungen und Produkte von SCHNITTWERK by Vanessa Carosella,
              Rorschacherstrasse 152, 9000 St. Gallen (nachfolgend "SCHNITTWERK"
              genannt). Mit der Inanspruchnahme unserer Dienstleistungen oder dem
              Kauf unserer Produkte akzeptieren Sie diese AGB.
            </p>
          </div>

          {/* Appointments */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">2. Terminbuchungen</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">2.1 Buchung</h3>
                <p>
                  Termine können online über unsere Website, telefonisch oder
                  persönlich im Salon gebucht werden. Eine Buchung ist erst
                  verbindlich, wenn Sie eine Bestätigung per E-Mail oder SMS
                  erhalten haben.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">2.2 Stornierung durch den Kunden</h3>
                <p>
                  Termine können bis 24 Stunden vor dem vereinbarten Zeitpunkt
                  kostenlos storniert oder verschoben werden. Bei Stornierungen
                  mit weniger als 24 Stunden Vorlauf oder bei Nichterscheinen ohne
                  Absage behalten wir uns vor, 50% des Dienstleistungspreises in
                  Rechnung zu stellen.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">2.3 Stornierung durch SCHNITTWERK</h3>
                <p>
                  SCHNITTWERK behält sich das Recht vor, Termine aus wichtigen
                  Gründen (z.B. Krankheit des Personals, höhere Gewalt) abzusagen.
                  In diesem Fall werden Sie umgehend informiert und es wird ein
                  Ersatztermin angeboten.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">2.4 Verspätung</h3>
                <p>
                  Bei Verspätung von mehr als 15 Minuten kann der Termin nicht
                  mehr in vollem Umfang durchgeführt werden oder muss neu
                  vereinbart werden. Der volle Preis wird dennoch fällig.
                </p>
              </div>
            </div>
          </div>

          {/* Services */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">3. Dienstleistungen</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">3.1 Leistungsumfang</h3>
                <p>
                  Die Durchführung der Dienstleistungen erfolgt nach bestem Wissen
                  und Gewissen durch unser qualifiziertes Personal. Der genaue
                  Leistungsumfang wird vor Beginn der Behandlung besprochen.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">3.2 Beratung</h3>
                <p>
                  Wir bieten eine umfassende Beratung an. Die finale Entscheidung
                  über die Durchführung einer Behandlung liegt beim Kunden. Wir
                  können keine Garantie für das Ergebnis übernehmen, wenn gegen
                  unsere Empfehlung gehandelt wird.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">3.3 Allergien und Unverträglichkeiten</h3>
                <p>
                  Kunden sind verpflichtet, uns vor Behandlungsbeginn über
                  bekannte Allergien, Unverträglichkeiten oder gesundheitliche
                  Einschränkungen zu informieren. SCHNITTWERK haftet nicht für
                  Schäden, die durch unterlassene Information entstehen.
                </p>
              </div>
            </div>
          </div>

          {/* Prices and Payment */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">4. Preise und Zahlung</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">4.1 Preise</h3>
                <p>
                  Alle Preise verstehen sich in Schweizer Franken (CHF) inklusive
                  der gesetzlichen Mehrwertsteuer. Preisänderungen bleiben
                  vorbehalten. Massgeblich ist der zum Zeitpunkt der Buchung
                  gültige Preis.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">4.2 Zahlungsbedingungen</h3>
                <p>
                  Die Zahlung erfolgt unmittelbar nach Erbringung der
                  Dienstleistung. Wir akzeptieren Barzahlung, EC-Karte,
                  Kreditkarte und Twint.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">4.3 Online-Shop</h3>
                <p>
                  Bei Online-Bestellungen erfolgt die Zahlung über unseren
                  Zahlungsdienstleister Stripe. Die Zahlung muss vor Versand der
                  Ware vollständig erfolgen.
                </p>
              </div>
            </div>
          </div>

          {/* Online Shop */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">5. Online-Shop</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">5.1 Vertragsabschluss</h3>
                <p>
                  Die Darstellung der Produkte im Online-Shop stellt kein
                  rechtlich bindendes Angebot dar. Durch Anklicken des Buttons
                  "Zahlungspflichtig bestellen" geben Sie eine verbindliche
                  Bestellung ab. Der Kaufvertrag kommt mit der Versendung der
                  Bestellbestätigung zustande.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">5.2 Lieferung</h3>
                <p>
                  Die Lieferung erfolgt an die von Ihnen angegebene Lieferadresse
                  innerhalb der Schweiz. Lieferzeiten sind Schätzungen und nicht
                  verbindlich. Die Lieferkosten werden vor Abschluss der
                  Bestellung angezeigt.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">5.3 Widerrufsrecht</h3>
                <p>
                  Bei Bestellungen im Online-Shop haben Sie das Recht, binnen 14
                  Tagen ohne Angabe von Gründen vom Vertrag zurückzutreten. Die
                  Frist beginnt mit Erhalt der Ware. Die Ware muss unbenutzt und
                  in der Originalverpackung zurückgesendet werden. Die Kosten der
                  Rücksendung trägt der Kunde.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">5.4 Gewährleistung</h3>
                <p>
                  Es gelten die gesetzlichen Gewährleistungsrechte. Bei Mängeln
                  kontaktieren Sie uns bitte umgehend unter info@schnittwerk.ch.
                </p>
              </div>
            </div>
          </div>

          {/* Liability */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">6. Haftung</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">6.1 Haftungsbeschränkung</h3>
                <p>
                  SCHNITTWERK haftet nur bei Vorsatz und grober Fahrlässigkeit.
                  Die Haftung für leichte Fahrlässigkeit ist ausgeschlossen, soweit
                  gesetzlich zulässig. Dies gilt nicht für Personenschäden.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">6.2 Garderobe und Wertsachen</h3>
                <p>
                  Für Garderobe, Wertsachen und andere mitgebrachte Gegenstände
                  übernehmen wir keine Haftung, es sei denn, diese werden
                  ausdrücklich zur Aufbewahrung übergeben.
                </p>
              </div>
            </div>
          </div>

          {/* Data Protection */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">7. Datenschutz</h2>
            <p className="text-schnittwerk-700">
              Die Verarbeitung Ihrer personenbezogenen Daten erfolgt gemäss
              unserer{" "}
              <a
                href="/datenschutz"
                className="font-medium text-gold-600 hover:text-gold-700"
              >
                Datenschutzerklärung
              </a>
              .
            </p>
          </div>

          {/* Customer Account */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">8. Kundenkonto</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">8.1 Registrierung</h3>
                <p>
                  Für die Nutzung bestimmter Funktionen (Online-Buchung,
                  Bestellhistorie) ist eine Registrierung erforderlich. Die
                  Angaben müssen wahrheitsgemäss und vollständig sein.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">8.2 Zugangsdaten</h3>
                <p>
                  Sie sind verpflichtet, Ihre Zugangsdaten geheim zu halten und
                  vor dem Zugriff Dritter zu schützen. Bei Verdacht auf Missbrauch
                  informieren Sie uns bitte umgehend.
                </p>
              </div>
            </div>
          </div>

          {/* Final Provisions */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">9. Schlussbestimmungen</h2>
            <div className="space-y-4 text-schnittwerk-700">
              <div>
                <h3 className="mb-2 font-semibold">9.1 Änderungen der AGB</h3>
                <p>
                  SCHNITTWERK behält sich das Recht vor, diese AGB jederzeit zu
                  ändern. Massgeblich ist die zum Zeitpunkt der Bestellung bzw.
                  Buchung gültige Fassung.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">9.2 Salvatorische Klausel</h3>
                <p>
                  Sollten einzelne Bestimmungen dieser AGB unwirksam sein oder
                  werden, berührt dies die Wirksamkeit der übrigen Bestimmungen
                  nicht.
                </p>
              </div>

              <div>
                <h3 className="mb-2 font-semibold">9.3 Anwendbares Recht und Gerichtsstand</h3>
                <p>
                  Es gilt ausschliesslich Schweizer Recht unter Ausschluss des
                  UN-Kaufrechts. Gerichtsstand ist St. Gallen, Schweiz, soweit
                  gesetzlich zulässig.
                </p>
              </div>
            </div>
          </div>

          {/* Contact */}
          <div>
            <h2 className="mb-4 text-2xl font-bold">10. Kontakt</h2>
            <p className="text-schnittwerk-700">
              Bei Fragen zu diesen AGB kontaktieren Sie uns bitte:
            </p>
            <div className="mt-4 space-y-2 text-schnittwerk-700">
              <p className="font-medium">SCHNITTWERK by Vanessa Carosella</p>
              <p>Rorschacherstrasse 152</p>
              <p>9000 St. Gallen</p>
              <p>
                E-Mail:{" "}
                <a
                  href="mailto:info@schnittwerk.ch"
                  className="hover:text-gold-600"
                >
                  info@schnittwerk.ch
                </a>
              </p>
              <p>
                Telefon:{" "}
                <a href="tel:+41712345678" className="hover:text-gold-600">
                  +41 71 234 56 78
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
