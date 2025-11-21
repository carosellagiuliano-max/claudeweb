import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Calendar, MapPin, Clock, Scissors } from "lucide-react";
import { ServiceCard } from "@/components/shared/ServiceCard";

export default function HomePage() {
  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section className="relative flex min-h-[90vh] items-center justify-center overflow-hidden bg-gradient-to-br from-schnittwerk-50 via-white to-gold-50">
        <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-5" />

        <div className="container-custom relative z-10 text-center">
          <h1 className="mb-6 text-5xl font-bold tracking-tight sm:text-6xl lg:text-7xl">
            SCHNITTWERK
            <span className="block text-4xl font-normal tracking-wide text-gold-600 sm:text-5xl lg:text-6xl">
              by Vanessa Carosella
            </span>
          </h1>

          <p className="mx-auto mb-8 max-w-2xl text-lg text-schnittwerk-600 sm:text-xl">
            Ihr moderner Friseursalon im Herzen von St. Gallen. Professionelle
            Haarschnitte, exklusive Färbungen und individuelles Styling.
          </p>

          <div className="flex flex-col items-center justify-center gap-4 sm:flex-row">
            <Button size="lg" className="w-full sm:w-auto" asChild>
              <Link href="/termin-buchen">
                <Calendar className="mr-2 h-5 w-5" />
                Jetzt Termin buchen
              </Link>
            </Button>
            <Button
              size="lg"
              variant="outline"
              className="w-full sm:w-auto"
              asChild
            >
              <Link href="/leistungen">Unsere Leistungen</Link>
            </Button>
          </div>
        </div>
      </section>

      {/* Info Cards */}
      <section className="container-custom py-16">
        <div className="grid gap-6 md:grid-cols-3">
          {/* Location Card */}
          <div className="glass group rounded-2xl p-8 transition-smooth hover:shadow-xl">
            <div className="mb-4 inline-flex rounded-full bg-gold-100 p-3">
              <MapPin className="h-6 w-6 text-gold-600" />
            </div>
            <h3 className="mb-2 text-xl font-semibold">Unser Standort</h3>
            <p className="mb-4 text-schnittwerk-600">
              Rorschacherstrasse 152<br />
              9000 St. Gallen
            </p>
            <a
              href="https://maps.google.com"
              target="_blank"
              rel="noopener noreferrer"
              className="text-sm font-medium text-gold-600 hover:text-gold-700"
            >
              In Google Maps öffnen →
            </a>
          </div>

          {/* Opening Hours Card */}
          <div className="glass group rounded-2xl p-8 transition-smooth hover:shadow-xl">
            <div className="mb-4 inline-flex rounded-full bg-gold-100 p-3">
              <Clock className="h-6 w-6 text-gold-600" />
            </div>
            <h3 className="mb-2 text-xl font-semibold">Öffnungszeiten</h3>
            <div className="space-y-1 text-schnittwerk-600">
              <p>Mo-Fr: 09:00 - 18:00</p>
              <p>Sa: 09:00 - 16:00</p>
              <p>So: Geschlossen</p>
            </div>
          </div>

          {/* Services Card */}
          <div className="glass group rounded-2xl p-8 transition-smooth hover:shadow-xl">
            <div className="mb-4 inline-flex rounded-full bg-gold-100 p-3">
              <Scissors className="h-6 w-6 text-gold-600" />
            </div>
            <h3 className="mb-2 text-xl font-semibold">Premium Services</h3>
            <p className="mb-4 text-schnittwerk-600">
              Haarschnitte, Färbungen, Styling, Treatments und mehr.
            </p>
            <Link
              href="/leistungen"
              className="text-sm font-medium text-gold-600 hover:text-gold-700"
            >
              Alle Leistungen ansehen →
            </Link>
          </div>
        </div>
      </section>

      {/* Featured Services */}
      <section className="container-custom py-20">
        <div className="mb-12 text-center">
          <h2 className="mb-4 text-3xl font-bold tracking-tight sm:text-4xl">
            Unsere Leistungen
          </h2>
          <p className="mx-auto max-w-2xl text-lg text-schnittwerk-600">
            Professionelle Haarpflege und Styling für jeden Anlass
          </p>
        </div>

        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <ServiceCard
            name="Damenhaarschnitt"
            description="Professioneller Haarschnitt inkl. Waschen und Föhnen"
            category="Haarschnitte"
            duration={60}
            price={7500}
            isPopular
          />
          <ServiceCard
            name="Herrenhaarschnitt"
            description="Moderner Herrenhaarschnitt inkl. Waschen"
            category="Haarschnitte"
            duration={45}
            price={5500}
          />
          <ServiceCard
            name="Komplettfärbung"
            description="Komplette Haarfärbung inkl. Pflege und Styling"
            category="Färbungen"
            duration={120}
            price={14500}
            isPopular
          />
        </div>

        <div className="mt-12 text-center">
          <Button size="lg" variant="outline" asChild>
            <Link href="/leistungen">Alle Leistungen ansehen</Link>
          </Button>
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-schnittwerk-900 py-20 text-white">
        <div className="container-custom text-center">
          <h2 className="mb-4 text-3xl font-bold sm:text-4xl">
            Bereit für Ihren neuen Look?
          </h2>
          <p className="mx-auto mb-8 max-w-2xl text-schnittwerk-200">
            Buchen Sie jetzt online Ihren Termin und lassen Sie sich von unserem
            professionellen Team verwöhnen.
          </p>
          <Button size="lg" variant="secondary" asChild>
            <Link href="/termin-buchen">
              <Calendar className="mr-2 h-5 w-5" />
              Termin buchen
            </Link>
          </Button>
        </div>
      </section>
    </div>
  );
}
