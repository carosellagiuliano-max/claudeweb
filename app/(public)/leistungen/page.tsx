import { ServiceCard } from "@/components/shared/ServiceCard";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { Calendar } from "lucide-react";

export const metadata = {
  title: "Leistungen",
  description:
    "Entdecken Sie unsere professionellen Friseurleistungen: Haarschnitte, Färbungen, Styling und mehr.",
};

export default function ServicesPage() {
  return (
    <div className="flex flex-col">
      {/* Header */}
      <section className="bg-gradient-to-br from-schnittwerk-50 via-white to-gold-50 py-20">
        <div className="container-custom text-center">
          <h1 className="mb-4 text-4xl font-bold tracking-tight sm:text-5xl">
            Unsere Leistungen
          </h1>
          <p className="mx-auto max-w-2xl text-lg text-schnittwerk-600">
            Professionelle Haarpflege und Styling-Services für jeden Anlass.
            Individuell auf Ihre Bedürfnisse abgestimmt.
          </p>
        </div>
      </section>

      {/* Haarschnitte */}
      <section className="container-custom py-16">
        <div className="mb-8">
          <h2 className="mb-2 text-2xl font-bold">Haarschnitte</h2>
          <p className="text-schnittwerk-600">
            Moderne Schnitte für jeden Stil - von klassisch bis trendy
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
            name="Kinderhaarschnitt"
            description="Haarschnitt für Kinder bis 12 Jahre"
            category="Haarschnitte"
            duration={30}
            price={3500}
          />
        </div>
      </section>

      {/* Färbungen */}
      <section className="bg-schnittwerk-50 py-16">
        <div className="container-custom">
          <div className="mb-8">
            <h2 className="mb-2 text-2xl font-bold">Färbungen & Colorationen</h2>
            <p className="text-schnittwerk-600">
              Vom natürlichen Look bis zur kompletten Typveränderung
            </p>
          </div>

          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <ServiceCard
              name="Komplettfärbung"
              description="Komplette Haarfärbung inkl. Pflege und Styling"
              category="Färbungen"
              duration={120}
              price={14500}
              isPopular
            />
            <ServiceCard
              name="Strähnchen"
              description="Feine Strähnchen für natürliche Highlights"
              category="Färbungen"
              duration={90}
              price={12000}
              isPopular
            />
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="container-custom py-20 text-center">
        <h2 className="mb-4 text-3xl font-bold">Bereit für Ihre Transformation?</h2>
        <p className="mx-auto mb-8 max-w-2xl text-schnittwerk-600">
          Buchen Sie jetzt online Ihren Termin oder rufen Sie uns an für eine
          persönliche Beratung.
        </p>
        <div className="flex flex-col items-center justify-center gap-4 sm:flex-row">
          <Button size="lg" asChild>
            <Link href="/termin-buchen">
              <Calendar className="mr-2 h-5 w-5" />
              Jetzt Termin buchen
            </Link>
          </Button>
          <Button size="lg" variant="outline" asChild>
            <Link href="/kontakt">Kontakt aufnehmen</Link>
          </Button>
        </div>
      </section>
    </div>
  );
}
