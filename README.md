# Generative Design

## Ideas
- NASA API von Meteoriten auf einer 3D Erde platzieren und animieren
- Sonnensystem mit physikalischen Formeln gestalten
- Interaktion mit der Kinect und Planeten/ Sterne durch physikalische Formel

Ich habe mich entschieden die letzte Idee umzusetzen.

## Konzeptioneller Ansatz


## Technische Umsetzung


## Gestaltungsmittel

## Realisierung

## Entwicklungprozess
Der Entwicklungsprozess bestand darin, dass ich anfangs viel Zeit in die andere beiden Idee investiert habe und dadurch dann weniger Zeit für meine neue und engültige Idee hatte.

Nach dem Ausleihen der Kinect habe ich mich im Internet informiert, wie man die Kinect in ein Processing Sketch einbinden kann und die Daten verarbeiten kann. Ich hatte vorher schon gesehen, dass dies gemacht wurde, es war also keine unüberlegte Idee, die Kinect mit Processing zu verbinden.

Ich habe dann recht schnell die nötigen Libraries gefunden und erforscht, wie ich die Kinect einbinde.

Danach habe ich nach einer _Anziehungs_-Formel gesucht, um im Sketch Kreise per Masse, nach physikalischen Gesetzen mit einander interagieren zu lassen.


## Bibliotheken & Tools
```
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
```
Mithilfe dieser Bilbiotheken wird eine Verbindung zur per USB-angeschlossenen Kinect aufzubauen.

Mit `Kinect2 kinect = new Kinect2(this);` wird dann ein Objekt erzeugt, mit dem man dann auf den Datenstrom der Kinect zugreifen kann.
```
kinect2.initVideo(); // bekommt die RGB Videostream der Kinect
kinect2.initDepth(); // die Tiefen
kinect2.initIR(); // Infrarot

kinect2.initDevice(); // Datenübertragung starten
```
