new moca.RPSet(xb).run();

def make = new moca.Make(xb);
if(xb.environment.products.les.child("include").exists()) {
  make.setTarget('superclean').run();
}

make.setTarget('config').run();
make.setTarget('install').run();
