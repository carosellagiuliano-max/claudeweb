import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

interface TeamCardProps {
  name: string;
  position: string;
  bio?: string;
  photoUrl?: string;
  specialties?: string[];
}

export function TeamCard({
  name,
  position,
  bio,
  photoUrl,
  specialties = [],
}: TeamCardProps) {
  // Generate initials for avatar fallback
  const initials = name
    .split(" ")
    .map((n) => n[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);

  return (
    <Card className="group overflow-hidden transition-all hover:shadow-lg">
      <CardHeader className="text-center">
        <div className="mb-4 flex justify-center">
          <Avatar className="h-24 w-24 ring-4 ring-white transition-transform group-hover:scale-105">
            <AvatarImage src={photoUrl} alt={name} />
            <AvatarFallback className="bg-gradient-to-br from-gold-400 to-gold-600 text-lg font-bold text-white">
              {initials}
            </AvatarFallback>
          </Avatar>
        </div>

        <CardTitle className="text-xl">{name}</CardTitle>
        <CardDescription className="text-gold-600 font-medium">
          {position}
        </CardDescription>
      </CardHeader>

      {(bio || specialties.length > 0) && (
        <CardContent className="text-center">
          {bio && (
            <p className="text-sm text-schnittwerk-600 leading-relaxed">
              {bio}
            </p>
          )}

          {specialties.length > 0 && (
            <div className="mt-4 flex flex-wrap justify-center gap-2">
              {specialties.map((specialty) => (
                <Badge key={specialty} variant="secondary" className="text-xs">
                  {specialty}
                </Badge>
              ))}
            </div>
          )}
        </CardContent>
      )}
    </Card>
  );
}
