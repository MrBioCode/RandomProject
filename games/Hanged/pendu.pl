#!/usr/local/bin/perl -w
use strict;
use warnings;
use dictionnaire_pendu;   # chargement du module


sub choix_mot{
	my @liste = @_ ;
	# retourne un element aleatoire dans une liste
	return $liste[int(rand(@liste))];
}

sub affichage_mot_cache{
	my ($mot, @lettres) = @_;
	# tant que des lettres non trouvees sont présentes
	while($mot =~ m/[^-@lettres]/i){ #utilisation de s///g pour remplacer la boucle
		# remplacer la premiere occurrence par "-"
		$mot =~ s/[^-@lettres]/-/i;
	}
	return $mot;
}

sub mot_complet{
	my ($mot_cache) = @_;
	#recherche si des lettres n'ont pas été trouvées.
	if($mot_cache =~ m/-/){
		return 0;
	}else{
		return 1;
	}
}

sub get_letter{
	my $in;
	print("Entrez une lettre : ");
	#recupere l'entree standard
	chomp($in=<STDIN>);
	# ne conserve que la premiere lettre
	$in=substr($in,0,1);
	# verif qu'il sagit bien d'une lettre
	while($in !~ m/[A-Za-z]/i){
		# redemande de saisir une lettre
		print("Erreur recommencez.\n");
		print("Entrez une lettre : ");
		chomp($in=<STDIN>);
		$in=substr($in,0,1);
	}
	return $in;
}

sub lettre_deja_utilise{
	my ($lettre,@lettres)=@_;
	if(@lettres){
		my @s = grep{$_ eq $lettre} @lettres;
		if(@s){
			print"Tu as déjà utilisé les lettres suivantes : @lettres.\n";
			return 0;
		}else{
			return 1;
		}
	}else{
		return 1;
	}
}

sub test_lettre{
	my ($i,$erreur_max,$mot,@lettres)=@_;
	my $lettre;
	do{
		$lettre=get_letter();
	}while( ! lettre_deja_utilise($lettre,@lettres));
	push(@lettres,$lettre);
	if($mot =~ m/$lettre/i){
		print("Bravo !\n");
	}else{
		$i++;
		print("Dommage ! Il te reste ",$erreur_max-$i," chance(s).\n");
	}
	return ($i,@lettres);
}

sub game{
	my @lettres=();
	my $lettre;
	my $mot=choix_mot(@dictionnaire_pendu::dico);
	my $i=0;
	my $erreur_max=10;
	my $mot_masque=affichage_mot_cache($mot,@lettres);
	print("Tu as $erreur_max erreur(s) autorisée(s).\n");

	do{
		print("Mot : $mot_masque\n");
		($i,@lettres)=test_lettre($i,$erreur_max,$mot,@lettres);
		$mot_masque=affichage_mot_cache($mot,@lettres);
		}while (mot_complet($mot_masque)!=1 and $i!= $erreur_max);
	if( $i==$erreur_max){
		print ("Tu as perdu ! le mot était : $mot.\n");
		return 0;
	}else{
		print ("Tu as gagné ! le mot était bien : $mot.\n");
		return 1;
	}
}
#######################################
################ MAIN #################
#######################################
my $partie=0;
my $gain=0;
my $again=0;
do{
	 $partie++;
	$gain+=game();
	print("Tu as gagné $gain fois en $partie partie(s).\n Veux tu rejouer ? (y/n)\n");
	if (get_letter()=~m/y/i){
		$again=1;
	}else{
		$again=0;
	}

}while ($again==1);

print("Au revoir.\n");








# open(my $file1,'<','./ODS5.txt') or die("open: $!");
# open(my $file2,'>','./ODS5_modif.txt') or die("open: $!");
# printf( $file2 "(" );
# my $word;
# while( defined( my $l = <$file1> ) ) {
#    chomp $l;
#    printf( $file2 "\"%s\",",$l );
# }
# printf( $file2 ")" ); 
# close( $file1 );
# close( $file2 );