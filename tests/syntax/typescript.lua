-- Generic React (TSX) sample for pop-in detection.
-- Covers the common captures whose treesitter color differs from the
-- pre-treesitter paint: @variable, @variable.member / @property,
-- @function.call, @type, parameters, JSX @tag / @tag.attribute / components.
return {
  filetype = "typescriptreact",
  lang = "tsx",
  code = [==[
import { useEffect, useState } from "react";
import { fetchProfile } from "./api";

interface ProfileProps {
  userId: string;
  compact?: boolean;
}

export function ProfileCard({ userId, compact }: ProfileProps) {
  const [profile, setProfile] = useState<Profile | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchProfile(userId)
      .then((result) => setProfile(result.data))
      .catch((reason) => setError(reason.message));
  }, [userId]);

  if (error !== null) {
    return <span className="error">{error}</span>;
  }

  const displayName = profile?.name ?? "Unknown";

  return (
    <article className={compact ? "card-compact" : "card"} data-id={userId}>
      <Avatar src={profile?.avatarUrl} alt={displayName} />
      <h2>{displayName}</h2>
    </article>
  );
}
]==],
}
