 %===========================================================================================%
 % Class File para reproducir un estilo similar a los textbooks del Open Logic Project en mi %
 % tesis                                                                                     %
 %===========================================================================================%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{itam-thesis}[2020/12/28 Clase de Tesis ITAM estilo Open Logic]

%================================%
% Declarando opciones de Paquete %
%================================%
\DeclareOption{colorful}{
	\AtEndOfClass{
		%=================%
		% Page dimensions %
		%=================%
		\usepackage[
				showframe,
				paperwidth=17cm,
				paperheight=22.5cm,
				nofoot=true,
				bindingoffset=1.1cm,
				inner=1.6cm,
				outer=1.8cm,
				top=2.5cm,
				bottom=1.5cm
			]{geometry}


		%===================%
		% Required packages %
		%===================%
		\RequirePackage{xcolor}
		\RequirePackage{mdframed}
		\RequirePackage{gitinfo2}
		\RequirePackage{amsmath}
		\RequirePackage{mathtools} % coloneqq
		\RequirePackage{graphicx}
		\RequirePackage{enumerate}
		\RequirePackage{tabularx}
		\RequirePackage{pgfplots}

		% load ntheorem before newtxmath to avoid multiple definition of \openbox
		\RequirePackage[
				thmmarks,
				amsmath,
				amsthm,
				hyperref
			]{ntheorem}

		% redefine proof-end symbol; ntheorem's \openbox gives a hacek-C
		% after a cases environment for some reason
		\gdef\proofSymbol{\ensuremath{\Box}}


		%=======%
		% Fonts %
		%=======%
		% Baskervald X for roman, with oldstyle figure
		\usepackage[osf]{Baskervaldx}
		% load amssymb before newtxmath to avoid problem with \Bbbk
		\usepackage{amssymb}
		% Nice math calligraphic font 
		\usepackage[cal=boondoxo]{mathalpha}
		% Math font to match
		\usepackage[bigdelims,baskervaldx]{newtxmath}

		% Chapter bar (?)
		\setlength{\barwidth}{7pt}
	}

	\AtBeginDocument{
		\def\figurename{Fig.}
	}
}

\ProcessOptions\relax

% Extendiendo clase memoir
\LoadClass[11pt,openany]{memoir}

% Renovando comando de hacer titulo para hacerlo estilo tesis
\renewcommand{\maketitle}{%
	\pagestyle{empty} % Suprime numero de página
	\begin{center}
	\textsc{\Large Instituto Tecnológico Autónomo de México}\\[2em]

	% Logo ITAM
	\begin{figure}[h]
	\begin{center}
	\includegraphics[scale=0.50]{img/logo-ITAM.pdf}
	\end{center}
	\end{figure}

	\textbf{\LARGE \@title }\\[2em]

	\textsc{\large Tesis}\\[1em]

	\textsc{\large que para obtener el título de}\\[1em]

	\textsc{\LARGE Licenciado en Matemáticas Aplicadas}\\[1em]

	\textsc{\large Presenta}\\[1em]

	\textsc{\LARGE \@author}\\[1em]

	\textsc{\large Asesor}\\[1em]

	\textsc{\LARGE Dr. Andreas Wachtel}\\[2em]

	\end{center}

	\vspace*{\fill}
	\textsc{Ciudad de México \hspace*{\fill} \@date}
	\newpage
}

\newcommand{\makefrontmatter}{
	\pagestyle{empty}
	\noindent

	\noindent Typeset in Baskervald X and Nimbus Sans by
	\LaTeX.

	\noindent This version is revision \gitAbbrevHash{} (\gitAuthorDate), with content generated

	\vfill

	\newpage
	\tableofcontents*
}

% Chapter style

% Define part and chapter styles

\newlength{\barwidth}

\makechapterstyle{OLPchapter}{%
	\setlength{\afterchapskip}{40pt}
	\setlength{\beforechapskip}{50pt}
	\setlength{\midchapskip}{10pt}
	\renewcommand*{\afterchapternum}{\par\nobreak\vskip 0pt}
	\renewcommand*{\chapnamefont}{\fontsize{14pt}{0pt}\selectfont\scshape\bfseries}
	\let\chapnumfont\chapnamefont
	\renewcommand*{\chaptitlefont}{\normalfont\fontsize{44pt}{44pt}\selectfont\bfseries\itshape\color{red}}
	\renewcommand*{\printchaptername}{%
		\chapnamefont\@chapapp
	}
	\renewcommand*{\printchaptertitle}[1]{%
		\chaptitlefont ##1\\[-\baselineskip]%
		\hspace*{-20pt}%
		\smash{\color{red}\rule{\barwidth}{350pt}}
	}
}

\renewcommand*{\partnamefont}{\fontsize{24pt}{0pt}\selectfont\bfseries\scshape}
\renewcommand*{\partnumfont}{\fontsize{24pt}{0pt}\selectfont\bfseries\sffamily}
\renewcommand*{\parttitlefont}{\normalfont\fontsize{54pt}{54pt}\selectfont\bfseries\itshape\color{blue}}
\renewcommand*{\printpartname}{%
	\partnamefont Part
}

\chapterstyle{OLPchapter}

\captionnamefont{\footnotesize\itshape\color{green}}
\captiontitlefont{\footnotesize}

\setlength{\cftbeforepartskip}{2em plus 0.5em minus 0.5em}
\setlength{\cftbeforechapterskip}{1.0em plus 0.5em minus 0.25em}
