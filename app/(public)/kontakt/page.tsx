import { Mail, Phone, MapPin, Clock } from "lucide-react";
import ContactForm from "@/components/shared/ContactForm";

export default function ContactPage() {
  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section className="relative flex min-h-[50vh] items-center justify-center overflow-hidden bg-gradient-to-br from-schnittwerk-50 via-white to-gold-50">
        <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-5" />

        <div className="container-custom relative z-10 text-center">
          <h1 className="mb-6 text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl">
            Kontakt
          </h1>
          <p className="mx-auto max-w-2xl text-lg text-schnittwerk-600 sm:text-xl">
            Wir sind für Sie da. Kontaktieren Sie uns für Terminvereinbarungen
            oder Fragen.
          </p>
        </div>
      </section>

      {/* Contact Information + Form */}
      <section className="container-custom py-20">
        <div className="grid gap-12 lg:grid-cols-2">
          {/* Contact Information */}
          <div className="space-y-8">
            <div>
              <h2 className="mb-6 text-3xl font-bold">
                Kontaktinformationen
              </h2>
              <p className="text-lg text-schnittwerk-600">
                Erreichen Sie uns telefonisch, per E-Mail oder besuchen Sie uns
                direkt im Salon.
              </p>
            </div>

            {/* Contact Cards */}
            <div className="space-y-6">
              {/* Address */}
              <div className="glass rounded-xl p-6">
                <div className="mb-3 inline-flex rounded-full bg-gold-100 p-3">
                  <MapPin className="h-6 w-6 text-gold-600" />
                </div>
                <h3 className="mb-2 text-lg font-semibold">Adresse</h3>
                <p className="text-schnittwerk-600">
                  SCHNITTWERK by Vanessa Carosella
                  <br />
                  Rorschacherstrasse 152
                  <br />
                  9000 St. Gallen
                  <br />
                  Schweiz
                </p>
                <a
                  href="https://maps.google.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="mt-3 inline-block text-sm font-medium text-gold-600 hover:text-gold-700"
                >
                  In Google Maps öffnen →
                </a>
              </div>

              {/* Phone */}
              <div className="glass rounded-xl p-6">
                <div className="mb-3 inline-flex rounded-full bg-gold-100 p-3">
                  <Phone className="h-6 w-6 text-gold-600" />
                </div>
                <h3 className="mb-2 text-lg font-semibold">Telefon</h3>
                <a
                  href="tel:+41712345678"
                  className="text-schnittwerk-600 hover:text-gold-600"
                >
                  +41 71 234 56 78
                </a>
              </div>

              {/* Email */}
              <div className="glass rounded-xl p-6">
                <div className="mb-3 inline-flex rounded-full bg-gold-100 p-3">
                  <Mail className="h-6 w-6 text-gold-600" />
                </div>
                <h3 className="mb-2 text-lg font-semibold">E-Mail</h3>
                <a
                  href="mailto:info@schnittwerk.ch"
                  className="text-schnittwerk-600 hover:text-gold-600"
                >
                  info@schnittwerk.ch
                </a>
              </div>

              {/* Opening Hours */}
              <div className="glass rounded-xl p-6">
                <div className="mb-3 inline-flex rounded-full bg-gold-100 p-3">
                  <Clock className="h-6 w-6 text-gold-600" />
                </div>
                <h3 className="mb-2 text-lg font-semibold">Öffnungszeiten</h3>
                <div className="space-y-1 text-schnittwerk-600">
                  <p>Montag - Freitag: 09:00 - 18:00</p>
                  <p>Samstag: 09:00 - 16:00</p>
                  <p>Sonntag: Geschlossen</p>
                </div>
              </div>
            </div>
          </div>

          {/* Contact Form */}
          <div>
            <div className="glass rounded-2xl p-8">
              <h2 className="mb-6 text-2xl font-bold">
                Schreiben Sie uns
              </h2>
              <ContactForm />
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
