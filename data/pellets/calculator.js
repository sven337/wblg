    function calculerPrix() {
        const prixWoodstock = parseFloat(document.getElementById('prixWoodstock').value);
        const prixLeclerc = parseFloat(document.getElementById('prixLeclerc').value);

        // Correction du prix Leclerc (PCI plus faible)
        const prixLeclercCorrige = prixLeclerc / 0.92;

        const difference = ((prixLeclercCorrige - prixWoodstock) / prixWoodstock * 100).toFixed(1);

        let message = '';
        if (prixLeclercCorrige <  prixWoodstock) {
            message = `Leclerc est moins cher de ${-difference}% (prix corrigé: ${prixLeclercCorrige.toFixed(2)}€)`;
        } else if (prixLeclercCorrige > prixWoodstock) {
            message = `Woodstock est moins cher de ${difference}% (prix Leclerc corrigé: ${prixLeclercCorrige.toFixed(2)}€)`;
        } else {
            message = "Les prix sont équivalents";
        }

        document.getElementById('resultat').innerHTML = message;
    }

