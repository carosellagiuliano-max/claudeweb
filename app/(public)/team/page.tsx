import { TeamCard } from "@/components/shared/TeamCard";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { Calendar } from "lucide-react";

export const metadata = {
  title: "Unser Team",
  description:
    "Lernen Sie das professionelle Team von SCHNITTWERK kennen - Experten für Haarschnitt, Färbung und Styling.",
};

export default function TeamPage() {
  return (
    <div className="flex flex-col">
      {/* Header */}
      <section className="bg-gradient-to-br from-schnittwerk-50 via-white to-gold-50 py-20">
        <div className="container-custom text-center">
          <h1 className="mb-4 text-4xl font-bold tracking-tight sm:text-5xl">
            Unser Team
          </h1>
          <p className="mx-auto max-w-2xl text-lg text-schnittwerk-600">
            Leidenschaftliche Profis mit jahrelanger Erfahrung und ständiger
            Weiterbildung. Wir freuen uns darauf, Sie zu verwöhnen.
          </p>
        </div>
      </section>

      {/* Team Members */}
      <section className="container-custom py-16">
        <div className="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
          <TeamCard
            name="Vanessa Carosella"
            position="Inhaberin / Master Stylist"
            bio="Inhaberin und Master Stylistin mit über 15 Jahren Erfahrung in der Branche. Spezialisiert auf kreative Schnitte und Colorationen."
            specialties={["Kreative Schnitte", "Balayage", "Hochsteckfrisuren"]}
          />

          <TeamCard
            name="Maria Müller"
            position="Senior Stylist"
            bio="Spezialistin für Färbungen und Colorationen mit einem Auge für natürliche Ergebnisse."
            specialties={["Färbungen", "Strähnchen", "Pflege"]}
          />

          <TeamCard
            name="Anna Schmidt"
            position="Stylist"
            bio="Expertin für Herrenhaarschnitte und modernes Styling mit Liebe zum Detail."
            specialties={["Herrenschnitte", "Fade Cuts", "Styling"]}
          />
        </div>
      </section>

      {/* Philosophy */}
      <section className="bg-schnittwerk-900 py-20 text-white">
        <div className="container-custom">
          <div className="mx-auto max-w-3xl text-center">
            <h2 className="mb-6 text-3xl font-bold">Unsere Philosophie</h2>
            <p className="mb-4 text-lg leading-relaxed text-schnittwerk-200">
              Bei SCHNITTWERK steht Ihre Zufriedenheit an erster Stelle. Wir
              nehmen uns Zeit für eine ausführliche Beratung und arbeiten mit
              hochwertigen Produkten, um das beste Ergebnis für Sie zu erzielen.
            </p>
            <p className="text-lg leading-relaxed text-schnittwerk-200">
              Unser Team bildet sich ständig weiter, um Ihnen die neuesten Trends
              und Techniken bieten zu können. Dabei verlieren wir nie den Blick
              für Ihre Individualität und Persönlichkeit.
            </p>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="container-custom py-20 text-center">
        <h2 className="mb-4 text-3xl font-bold">Lernen Sie uns kennen</h2>
        <p className="mx-auto mb-8 max-w-2xl text-schnittwerk-600">
          Vereinbaren Sie einen Termin und erleben Sie selbst, wie wir mit
          Leidenschaft und Expertise Ihren perfekten Look kreieren.
        </p>
        <Button size="lg" asChild>
          <Link href="/termin-buchen">
            <Calendar className="mr-2 h-5 w-5" />
            Jetzt Termin buchen
          </Link>
        </Button>
      </section>
    </div>
  );
}
