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
		% \usepackage[
		% 		showframe,
		% 		paperwidth=17cm,
		% 		paperheight=22.5cm,
		% 		nofoot=true,
		% 		bindingoffset=1.1cm,
		% 		inner=1.6cm,
		% 		outer=1.8cm,
		% 		top=2.5cm,
		% 		bottom=1.5cm
		% 	]{geometry}


		%===================%
		% Required packages %
		%===================%
		\RequirePackage{xcolor}
		\RequirePackage[dirty=dirty]{gitinfo2}
		\RequirePackage{amsmath}
		\RequirePackage{mathtools} % coloneqq
		\RequirePackage{graphicx}
		\RequirePackage{enumerate}
		\RequirePackage{tabularx}
		\RequirePackage{tikz}
		\RequirePackage{pgfplots}
		\RequirePackage{float}
		\RequirePackage[many]{tcolorbox}
		\RequirePackage{listings} % Code listings
		\RequirePackage{fontspec} % For custom ttfont
		\RequirePackage{hyperref}
		\RequirePackage{mathtools}
		% \RequirePackage{mdframed}

		% % load ntheorem before newtxmath to avoid multiple definition of \openbox
		% \RequirePackage[
		% 		thmmarks,
		% 		amsmath,
		% 		amsthm,
		% 		hyperref
		% 	]{ntheorem}



		% redefine proof-end symbol; ntheorem's \openbox gives a hacek-C
		% after a cases environment for some reason
		% \gdef\proofSymbol{\ensuremath{\Box}}


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
	\includegraphics[scale=0.50]{img/logo_ITAM.pdf}
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
	{
		\small
		\noindent
		\textsc{Ciudad de México \hspace*{\fill} \@date}
	}
	\newpage
}

\newcommand{\makefrontmatter}{
	\vspace*{\fill}
	\noindent Typeset by the author in Baskervald X, Nimbus 
	Sans and Julia Mono (github.com/cormullion/juliamono) by 
	\LaTeX.

	\noindent This version is corresponds to commit 
	\texttt{\gitAbbrevHash{}} on branch: \texttt{\gitBranch{}}, 
	committed on \textit{\gitAuthorDate{}}. The working tree is 
	\gitDirty{}

	\newpage

	\thispagestyle{empty}

	\vspace*{\fill}
	\begingroup

	\noindent
	{
	\fontfamily{lmr}\selectfont
	<<Con fundamento en los artículos 21 y 27 de la Ley Federal 
	del Derecho de Autor y como titular de los derechos moral y 
	patrimonial de la obra titulada ``\textbf{\@title}'', 
	otorgo de manera gratuita y permanente al Instituto 
	Tecnológico Autónomo de México y a la Biblioteca Raúl 
	Baill\`eres Jr., la autorización para que fijen la obra en 
	cualquier medio, incluido el electrónico, y la divulguen 
	entre sus usuarios, profesores, estudiantes o terceras 
	personas, sin que pueda percibir por tal divulgación una 
	contraprestación.>>
	\normalfont
	}

	\centering 

	\vspace{5em}

	\rule[1em]{20em}{0.5pt} % Línea para la fecha

	\textsc{Fecha}
	 
	\vspace{5em}

	\rule[1em]{20em}{0.5pt} % Línea para la firma

	\textsc{\@author}

	\endgroup
	\vspace*{\fill}

	\newpage
}

%=========================================================%
% Part, Chapter and Sections styles---------------------- %
%=========================================================%

% Vertical bar length
\newlength{\barwidth}

%================%
% Chapter styles %
%================%
\makechapterstyle{OLPchapter}{%
	% Spacing
	\setlength{\afterchapskip}{40pt}
	\setlength{\beforechapskip}{50pt}
	\setlength{\midchapskip}{10pt}
	% Chapter Name (Chapter x)
	\renewcommand*{\afterchapternum}{\par\nobreak\vskip 0pt}
	\renewcommand*{\chapnamefont}{\fontsize{14pt}{0pt}\selectfont\scshape\bfseries\color{nightDarkest}}
	\let\chapnumfont\chapnamefont
	% Chapter title - Fonts and color
	\renewcommand*{\chaptitlefont}{\normalfont\fontsize{44pt}{44pt}\selectfont\bfseries\itshape\color{nightMid}}
	\renewcommand*{\printchaptername}{%
		\chapnamefont\@chapapp
	}
	% Chapter vertical bar
	\renewcommand*{\printchaptertitle}[1]{%
		\chaptitlefont ##1\\[-\baselineskip]%
		\hspace*{-20pt}%
		\smash{\color{frostDarkBlue}\rule{\barwidth}{350pt}}
	}
}

%=============%
% Part styles %
%=============%
\renewcommand*{\partnamefont}{\fontsize{24pt}{0pt}\selectfont\bfseries\scshape\color{nightDarkest}}
\renewcommand*{\partnumfont}{\fontsize{24pt}{0pt}\selectfont\bfseries\scshape\color{nightDarkest}}
\renewcommand*{\parttitlefont}{\normalfont\fontsize{54pt}{54pt}\selectfont\bfseries\itshape\color{nightDark}}
\renewcommand*{\printpartname}{%
	\partnamefont Part
}

\chapterstyle{OLPchapter}

%================%
% Section styles %
%================%
% Changing section colors
% Section
\setsecheadstyle{\Large\bfseries\color{nightDarkest}}
% Subsection
\setsubsecheadstyle{\large\bfseries\color{nightDarkest}}
% Subsubsection
\setsubsubsecheadstyle{\bfseries\color{nightDark}}

% Caption styles
\captionnamefont{\footnotesize\itshape\color{nightLight}}
\captiontitlefont{\footnotesize}

\setlength{\cftbeforepartskip}{2em plus 0.5em minus 0.5em}
\setlength{\cftbeforechapterskip}{1.0em plus 0.5em minus 0.25em}
