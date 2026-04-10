{ pipeline }:
assert pipeline.normalized.users.Shetty.userId == "Shetty";
assert pipeline.normalized.users.Shetty.initialHashedPassword
  == "$y$j9T$IbyB4U5AIUqcxol3JR60E0$/Wr3iDHuKpYBX7lkBSMJHGWlRS3quNv.DqQvkpKK4dD";
assert pipeline.normalized.hosts."Shetty-Laptop".hostId == "Shetty-Laptop";
assert pipeline.normalized.relations."Shetty@Shetty-Laptop".relationId
  == "Shetty@Shetty-Laptop";
true
