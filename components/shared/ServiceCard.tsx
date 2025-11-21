import { Clock, Euro } from "lucide-react";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { formatCurrency } from "@/lib/utils";

interface ServiceCardProps {
  name: string;
  description?: string;
  duration: number; // in minutes
  price: number; // in cents
  category?: string;
  isPopular?: boolean;
}

export function ServiceCard({
  name,
  description,
  duration,
  price,
  category,
  isPopular = false,
}: ServiceCardProps) {
  return (
    <Card className="group relative overflow-hidden transition-all hover:shadow-lg">
      {isPopular && (
        <div className="absolute right-4 top-4">
          <Badge variant="secondary">Beliebt</Badge>
        </div>
      )}

      <CardHeader>
        {category && (
          <p className="text-xs font-medium uppercase tracking-wide text-gold-600">
            {category}
          </p>
        )}
        <CardTitle className="mt-2">{name}</CardTitle>
        {description && (
          <CardDescription className="mt-2">{description}</CardDescription>
        )}
      </CardHeader>

      <CardContent>
        <div className="flex items-center gap-6 text-sm text-schnittwerk-600">
          <div className="flex items-center gap-1.5">
            <Clock className="h-4 w-4" />
            <span>{duration} Min.</span>
          </div>
          <div className="flex items-center gap-1.5 font-semibold text-schnittwerk-900">
            <Euro className="h-4 w-4" />
            <span>{formatCurrency(price / 100)}</span>
          </div>
        </div>
      </CardContent>

      <CardFooter>
        <Button className="w-full" variant="outline">
          Jetzt buchen
        </Button>
      </CardFooter>
    </Card>
  );
}
