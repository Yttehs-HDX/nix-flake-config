{ pipeline }:
assert pipeline.normalized.users.Shetty.userId == "Shetty";
assert pipeline.normalized.hosts."Shetty-Laptop".hostId == "Shetty-Laptop";
assert pipeline.normalized.relations."Shetty@Shetty-Laptop".relationId
  == "Shetty@Shetty-Laptop";
true
